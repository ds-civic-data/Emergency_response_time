Tree Species Index
================
------------------------------------------------------------------------
4/20/2018

We will propose a simple system for indexing the different species of trees, based on whether a tree is native, large, or evergreen, using the following formula:

*I* = *S* + *N* + *E*

The variable *S*, based on size, takes a value of 1/3/5 for small/medium/large trees. The variable *N* refers to whether or not a tree is native, taking a value of 1 for native trees and 0 for all other trees. Finally, *E* takes a value of 2 for evergreen trees, and 0 for all other trees. A tree will have an index value from 1 (worst) to 8 (best).

``` r
# load up tidy dataset
trees <- read.csv("~/emergency-response-time/data/tree_tidy.csv")
```

``` r
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
```

    ## 'data.frame':    41959 obs. of  16 variables:
    ##  $ xcoord     : num  7653423 7653423 7653423 7653423 7654347 ...
    ##  $ ycoord     : num  691920 691920 691920 691920 693381 ...
    ##  $ year       : int  2008 2008 2008 2008 2008 2008 2008 2008 2008 2008 ...
    ##  $ name       : Factor w/ 147 levels "Alaska yellow-cedar",..: 119 143 143 143 119 119 14 14 14 14 ...
    ##  $ size       : Factor w/ 3 levels "L","M","S": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ canopy_rad : int  60 60 60 60 60 60 60 60 60 60 ...
    ##  $ canopy_area: num  11310 11310 11310 11310 11310 ...
    ##  $ native     : logi  FALSE TRUE TRUE TRUE FALSE FALSE ...
    ##  $ nuisance   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
    ##  $ edible     : Factor w/ 3 levels "fruit","none",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##  $ family     : Factor w/ 39 levels "Altingiaceae",..: 14 10 10 10 14 14 34 34 34 34 ...
    ##  $ species    : Factor w/ 147 levels "Abies grandis",..: 113 137 137 137 113 113 8 8 8 8 ...
    ##  $ origin     : Factor w/ 6 levels "Africa","Asia",..: 5 5 5 5 5 5 5 5 5 5 ...
    ##  $ funct      : Factor w/ 4 levels "BD","BE","CD",..: 1 4 4 4 1 1 1 1 1 1 ...
    ##  $ group      : Factor w/ 4 levels "contractor","park",..: 4 4 4 4 4 4 4 4 4 4 ...
    ##  $ index      : num  5 8 8 8 5 5 6 6 6 6 ...

``` r
# export new tidy, tree index

setwd("~/emergency-response-time/data")
write.csv(tree_tidy_index, "tree_tidy_index.csv",row.names=F)
write.csv(tree_index, "tree_index.csv",row.names=F)
```
