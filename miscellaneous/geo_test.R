library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)
library(maps)
library(scales)

setwd("~/emergency-response-time/data-raw/census-tracts")
location <- readOGR(dsn = ".", layer ="tract2010")
cnty <- map_data("county")
joined <- read.csv("~/emergency-response-time/data/census_tract.csv")

trees <- read.csv("~/emergency-response-time/data/tree_tidy.csv")

lonlat <- cbind(trees$xcoord,trees$ycoord)
pts <- SpatialPoints(lonlat)

crdref <- CRS('+proj=longlat +datum=WGS84')
pts <- SpatialPoints(lonlat, proj4string=crdref)

showDefault(pts)

location <- location %>%
  spTransform(CRS("+init=epsg:4326"))

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
test <- extractCoords(location)

df <- as.data.frame(do.call(rbind, test))
names(df) <- c("lon", "lat", "group", "fips")
df$lon <- as.numeric(as.character(df$lon))
df$lat <- as.numeric(as.character(df$lat))
df$group <- as.numeric(as.character(df$group))
df$fips <- as.numeric(as.character(df$fips))

tract_income <- full_join(joined, df, by = c("Geo_FIPS" = "fips"))

tract_income %>%
  filter(lon > -122.78562 & lon < -122.48032, lat > 45.44466 & lat < 45.64596) %>%
  filter(!is.na(SE_T061_001)) %>%
  ggplot() + 
  geom_polygon(aes(x=lon,y=lat,group=group, fill=SE_T061_001),
               color="black",size=0.3)

