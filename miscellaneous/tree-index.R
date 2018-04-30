library(tidyverse)

# load up tidy dataset
trees <- read.csv("~/emergency-response-time/data/tree_tidy.csv")

# get rid of cols we don't need
index_build <- trees %>%
  select(species, funct, size, native)
# mutate a whole bunch of numeric variables
index_build <- trees %>%
  mutate(s = ifelse(size=="S", 1,
                    ifelse(size=="M", 3, 5))) %>%
  mutate(n = ifelse(native, 1, 0)) %>%
  mutate(e = ifelse(funct %in% c("BE","CE"),2, 0)) %>%
  # mutate index
  mutate(index = s + n + e)

# make a simple index of all the species
tree_index <- index_build %>%
  select(species,index) %>%
  group_by(species) %>%
  summarize(index=mean(index))

# full join index and tidy set
tree_tidy_index <- trees %>%
  full_join(tree_index,by=c("species"="species"))
str(tree_tidy_index)

# export new tidy, tree index
setwd("~/emergency-response-time/data")
write.csv(tree_tidy_index,
          "~/emergency-response-time/data/tree_tidy_index.csv",row.names=F)
write.csv(tree_index, 
          "~/emergency-response-time/data/tree_index.csv",row.names=F)
