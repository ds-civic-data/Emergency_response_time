Tree Species Index
================
------------------------------------------------------------------------
4/20/2018

We will propose a simple system for indexing the different species of trees:

*i**n**d**e**x* = *e**v**e**r**g**r**e**e**n* + *s* + *n**a**t**i**v**e* − *n**u**i**s**a**n**c**e* − *p**o**p**u**l**a**r**i**t**y*

*e**v**e**r**g**r**e**e**n* takes a value of 5 if the tree is evergreen, and is 0 otherwise.

*s* is the square root of a tree's canopy radius.

*n**a**t**i**v**e* takes a value of 5 if the tree is native, and is 0 otherwise.

*n**u**i**s**a**n**c**e* takes a value of 5 if the tree is a nuisance plant, and 0 otherwise.

*p**o**p**u**l**a**r**i**t**y* is the natural log of the number of times the tree has been planted recently.

``` r
# load up tidy dataset
trees <- read.csv("~/emergency-response-time/data/tree_tidy.csv")
```

``` r
# get rid of cols we don't need
index_build <- trees %>%
  select(-name, -xcoord,-ycoord,-year,-size,-canopy_area,-family,-edible
        -origin,-group) %>%
  select(species, funct, canopy_rad, native, nuisance)
# mutate a whole bunch of numeric variables
index_build <- trees %>%
  group_by(species) %>%
  mutate(tot=n(), pop = log(tot)) %>%
  mutate(s=sqrt(canopy_rad)) %>%
  mutate(nat=ifelse(native,5,0)) %>%
  mutate(nuis=ifelse(nuisance,5,0)) %>%
  mutate(ever=ifelse(funct=="BE"|funct=="CE",5,0)) %>%
  # mutate index
  mutate(index = ever+s+nat-nuis-pop)

# make a simple index of all the species
tree_index <- index_build %>%
  select(species,index) %>%
  group_by(species) %>%
  summarize(index=mean(index))

# full join index and tidy set
tree_tidy_index <- trees %>%
  full_join(tree_index,by=c("species"="species"))
```

``` r
# export new tidy, tree index

setwd("~/emergency-response-time/data")
write.csv(tree_tidy_index, "tree_tidy_index.csv",row.names=F)
write.csv(tree_index, "tree_index.csv",row.names=F)
```
