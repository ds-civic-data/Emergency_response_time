library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)
library(maps)
library(scales)
library(raster)
library(broom)
library(RColorBrewer)

# read spatial data
setwd("~/emergency-response-time/data-raw/census-tracts")
location <- readOGR(dsn = ".", layer ="tract2010")

# read income csv data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")

medianincome_small <- medianincome %>%
 dplyr::select(Geo_FIPS, SE_T061_001)

names(medianincome_small) <- c("FIPS","income")

location <- location %>%
  spTransform(CRS("+init=epsg:4326"))

m <- merge(location, medianincome_small, by="FIPS")

my_colors = brewer.pal(5, "Blues") 
my_colors = colorRampPalette(my_colors)(15)

class_of_tract= cut(m@data$income, 15)
my_colors=my_colors[as.numeric(class_of_tract)]

plot(m, col=my_colors, xlim=c(-122.78562, -122.48032),
     ylim=c(45.44466, 45.64596))

mf <- fortify(m, region="FIPS")


medianincome$Geo_FIPS <- as.character(medianincome$Geo_FIPS)

ggplot() + geom_map(data = m@data, aes(map_id=FIPS, fill=income), 
                    map = mf)

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
loc_df$lon <- as.numeric(as.character(loc_df$lon))
loc_df$lat <- as.numeric(as.character(loc_df$lat))
loc_df$group <- as.numeric(as.character(loc_df$group))
loc_df$fips <- as.numeric(as.character(loc_df$fips))

########################################
# add income
# join location df with income data
full_spatial <- full_join(medianincome, loc_df, by=c("Geo_FIPS"="fips"))

full_spatial <- full_spatial %>%
  select(lon, lat, group, SE_T061_001, Geo_GEOID)

names(full_spatial) <- c("lon","lat","group","income","geoid")

nrow(full_spatial)
full_spatial %>%
  filter(!is.na(income)) %>%
  nrow()

ggplot() +
  geom_polygon(data=full_spatial,aes(x=lon,y=lat,group=group, fill=income),
               color="black",size=0.3)


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

