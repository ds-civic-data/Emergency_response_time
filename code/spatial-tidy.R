library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)
library(maps)
library(scales)

# read spatial data
setwd("~/emergency-response-time/data-raw/census-tracts")
location <- readOGR(dsn = ".", layer ="tract2010")

# read income csv data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")

########################################
# tidy spatial data, extract coordinates into dataframe

location <- location %>%
  spTransform(CRS("+init=epsg:4326"))

#function to extract coordinates from polygon shapefile
extractCoords <- function(sp.df){
  coords <- list()
  it <- length(sp.df@polygons)
  for(i in 1:it){
    group <- rep(i, nrow(sp.df@polygons[[i]]@Polygons[[1]]@coords))
    fips <- rep(levels(sp.df@data$FIPS)[i], 
                nrow(sp.df@polygons[[i]]@Polygons[[1]]@coords))
    coords[[i]] <- cbind(sp.df@polygons[[i]]@Polygons[[1]]@coords, group, fips)
  }
  coords
}

loc_coords <- extractCoords(location)

# convert coordinates into dataframe, tidy it
loc_df <- as.data.frame(do.call(rbind, loc_coords))
names(loc_df) <- c("lon", "lat", "group", "fips")
loc_df$lon <- as.numeric(as.character(df$lon))
loc_df$lat <- as.numeric(as.character(df$lat))
loc_df$group <- as.numeric(as.character(df$group))
loc_df$fips <- as.numeric(as.character(df$fips))

########################################
# add income
# join location df with income data
full_spatial <- full_join(medianincome, loc_df, by=c("Geo_FIPS"="fips"))

full_spatial <- full_spatial %>%
  select(lon, lat, group, SE_T061_001, Geo_GEOID)

names(full_spatial) <- c("lon","lat","group","income","geoid")

# mutate income column
pdx_mean_inc <- 77208
full_spatial <- full_spatial %>%
  mutate(inc_level = ifelse(income>(.8*pdx_mean_inc), "normal",
                            ifelse(income>(.5*pdx_mean_inc), "low", "very_low")))

# filter coordinates to only include inner portland 
full_spatial <- full_spatial %>%
  filter(lon > -122.78562 & lon < -122.48032, lat > 45.44466 & lat < 45.64596)

########################################
# export tidy spatial data
write.csv(full_spatial, "~/emergency-response-time/data/spatial_tidy.csv",
          row.names=F)

