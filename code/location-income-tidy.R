library(tidyverse)
library(raster)
library(sp)


# read spatial data
setwd("~/emergency-response-time/data-raw/census-tracts")
location <- shapefile("~/emergency-response-time/data-raw/census-tracts/tract2010.shp")

# read income csv data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")

  names(medianincome)[names(medianincome) == 'Geo_FIPS'] <- 'FIPS'

# merge 
location_income <- merge(location, medianincome, by='FIPS')

# save as shapefile again
shapefile(location_income, "~/emergency-response-time/data/merged.shp")
