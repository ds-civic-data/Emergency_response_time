library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)

# read data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")

treetract <- read.csv("~/emergency-response-time/data/tree_tract.csv")

# tidy data
medianincome <- medianincome %>%
  select(Geo_FIPS, Geo_GEOID, Geo_NAME, Geo_QName, Geo_TRACT, SE_T061_001)

# join data
complete_tablejoin <- full_join(medianincome, treetract, by = c("Geo_FIPS" = "FIPS")) 

# more tidying 
complete_tablejoin <- complete_tablejoin %>%
  select(Geo_GEOID, Year_Plant, Common_nam, Genus_spec, Size, Native, Functional,
         SE_T061_001)

# export data
write.csv(complete_tablejoin, 
          "~/emergency-response-time/data/complete_tablejoin.csv", row.names = F)

