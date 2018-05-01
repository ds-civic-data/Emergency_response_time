library(tidyverse)

# read data
trees <- read.csv("~/emergency-response-time/data/complete_tablejoin.csv")

########################################
# transform data (tree stuff)
trees <- trees %>%
  # filter out trees with no native val, make better "native" col
  filter(Native %in% c("Yes","No")) %>%
  mutate(native=ifelse(Native=="Yes",T,F)) %>%
  select(-Native) %>%
  # mutate radius, area for canopy cover
  mutate(canopy_rad=ifelse(Size=="L", 60,
                           ifelse(Size=="M", 40, 20))) %>%
  mutate(canopy_area = pi*canopy_rad^2) %>%
  # mutate cols for broadleaf/conifer and deciduous/evergreen
  mutate(type=ifelse(Functional=="BD"|Functional=="CD", "deciduous", "evergreen")) %>%
  select(-Functional)

# reorder and rename cols
trees <- trees %>%
  select(lon, lat, Common_nam,Genus_spec,Year_Plant, Size, native,
         canopy_rad, canopy_area, type, SE_T061_001,Geo_GEOID)

names(trees) <- c("lon","lat","name","species","year","size","native","canopy_rad",
                  "canopy_area","type","income","geoid")

########################################
# transform data (inome stuff)
pdx_mean_inc <- 77208

trees <- trees %>%
  mutate(inc_level = ifelse(income>(.8*pdx_mean_inc), "normal",
                            ifelse(income>(.5*pdx_mean_inc), "low", "very_low")))

########################################
# create tree index
# get rid of cols we don't need
index_build <- trees %>%
  select(name, type, size, native)
# mutate a whole bunch of numeric variables
index_build <- trees %>%
  mutate(s = ifelse(size=="S", 1,
                    ifelse(size=="M", 3, 5))) %>%
  mutate(n = ifelse(native, 1, 0)) %>%
  mutate(e = ifelse(type=="evergreen",2, 0)) %>%
  # mutate index
  mutate(index = s + n + e)

# make a simple index of all the species
tree_index <- index_build %>%
  select(name,index) %>%
  group_by(name) %>%
  summarize(index=mean(index))
glimpse(tree_index)

# full join index and tidy set
tree_tidy_index <- trees %>%
  full_join(tree_index,by=c("name"="name"))

########################################
# export new tidy table as csv
write.csv(trees, "~/emergency-response-time/data/fulltable_tidy.csv",row.names=F)

# export tree index
write.csv(tree_index, 
          "~/emergency-response-time/data/tree_index.csv",row.names=F)

