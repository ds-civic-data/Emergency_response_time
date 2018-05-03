library(dplyr)
library(rgeos)
library(maptools)

# read spatial data
setwd("~/emergency-response-time/data/merged_spatial")
location_income <- readOGR(dsn = ".", layer = "merged")
locin <- location_income@data

library(ggplot2)
fortifylc <- fortify(location_income, region = "FIPS")
ggplot() + geom_map(data = locin, aes(map_id = FIPS, fill = SE_T061), 
                    map = fortifylc) + expand_limits(x = fortifylc$long, y = fortifylc$lat) 
