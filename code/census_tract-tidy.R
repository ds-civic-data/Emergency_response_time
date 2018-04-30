library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)

# read data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")
setwd("~/emergency-response-time/data-raw/census-tracts")
location <- readOGR(dsn = ".", layer ="tract2010")

medianincome <- medianincome %>%
  select(Geo_FIPS, Geo_GEOID, Geo_NAME, Geo_QName, Geo_TRACT, SE_T061_001)

proj4string(location)
location_proj <- location %>%
  spTransform(CRS("+init=epsg:4326")) %>%
  as.data.frame() %>%
  select(TRACT, TRACT_NO, FIPS) %>%
  mutate(numFIPS = as.numeric(FIPS))

census_tract <- full_join(medianincome, location_proj, by = c("Geo_FIPS" = "numFIPS")) 

write.csv(census_tract, "~/emergency-response-time/data/census_tract.csv", row.names = F)

