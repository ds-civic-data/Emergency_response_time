Data Tidying
================

-   [Overview](#overview)
    -   [Raw Data](#raw-data)
    -   [Data Needed](#data-needed)
-   [Tidying](#tidying)
    -   [Import](#import)
    -   [Reproject both shapefiles](#reproject-both-shapefiles)
    -   [Build income/tract shapefile](#build-incometract-shapefile)
        -   [Tidy income data, then merge it with tracts](#tidy-income-data-then-merge-it-with-tracts)
    -   [Tree data](#tree-data)
        -   [Perform a spatial join over trees, tract data](#perform-a-spatial-join-over-trees-tract-data)
        -   [Initial tidying step](#initial-tidying-step)
        -   [Join with income data](#join-with-income-data)
        -   [Make a tree index](#make-a-tree-index)
        -   [Join with survey data](#join-with-survey-data)

Overview
========

Raw Data
--------

-   FoT and City street tree planting data (shapefile)

-   2010 tree inventory data (csv)

-   Median income tract data (csv)

-   Census tracts (shapefile)

Data Needed
-----------

-   Income + tract shapefile for building choropleths

-   Tree dataset 1989-2018 for analyzing planting trends

-   Tree dataset 1989-2009 for analyzing tree persistence

-   Tree index by species for future use

Tidying
=======

Import
------

``` r
# Street tree planting (not on github on account of size)
setwd("~/emergency-response-time/data-raw/tree-spatial")
planting <- readOGR(dsn = ".", layer = "All_trees_3_2018_species")
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: ".", layer: "All_trees_3_2018_species"
    ## with 54009 features
    ## It has 23 fields

``` r
# Street tree inventory
setwd("~/emergency-response-time/data-raw")
survey <- read.csv("street_trees_current.csv")

# Median income data
medinc <- read.csv("median_income.csv")

# Census tract shapefile
setwd("~/emergency-response-time/data-raw/census-tracts")
tracts <- readOGR(dsn = ".", layer = "tract2010")
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: ".", layer: "tract2010"
    ## with 491 features
    ## It has 16 fields

Reproject both shapefiles
-------------------------

``` r
planting <- planting %>%
  spTransform(CRS("+init=epsg:4326"))

tracts <- tracts %>%
  spTransform(CRS("+init=epsg:4326"))
```

Build income/tract shapefile
----------------------------

### Tidy income data, then merge it with tracts

``` r
# we only need the income column and a geographic identifier (FIPS)
medinc <- medinc %>%
  dplyr::select(Geo_FIPS, SE_T061_001)
# rename cols
names(medinc) <- c("FIPS","income")

# merge by FIPS column
tract_inc <- merge(tracts, medinc, by = "FIPS")
```

The shapefile `tract_inc` is all we need to create a census tract/income layer for any maps.

Tree data
---------

### Perform a spatial join over trees, tract data

**This cannot be done on the local Rstudio server.** I performed this operation on my personal computer using the following code:

``` r
library(spatialEco)

tract_list <- tracts %>%
  select(lon, lat, group) %>%
  split(tracts$group)
tract_list <- lapply(tract_list, function(x) { x["group"] <- NULL; x })

ps <- sapply(tract_list, Polygon)
p1 <- Polygons(ps, ID = 1)
tract_spatial <- SpatialPolygons(list(p1),proj4string = CRS("+init=epsg:4326"))

points <- point.in.poly(planting, orig_tracts)

tree_proj <- planting %>%
  as.data.frame() %>%
  select(`coords.x1`,`coords.x2`)
names(tree_proj) <- c("lon","lat")

tree_tract <- cbind(tree_proj, points)
```

Here, `tree_tract` is a csv file where each observation is a tree. It contains all the tree information contained in `planting`, but also specifies the coordinates and tract of each tree.

``` r
# load in new tree csv
trees <- read.csv("tree_tract.csv")
```

### Initial tidying step

``` r
# select+rename relevant columns
trees <- trees %>%
  dplyr::select(lon, lat, Year_Plant, Planting_O, Address, Common_nam,
         Genus_spec, Functional, Size, Native, FIPS)
names(trees) <- c("lon","lat","year","Org","address","name","species","Group",
                  "size","Native","FIPS")

# transformation step
# mutate a better "native" column
trees <- trees %>%
  filter(Native %in% c("Yes","No")) %>%
  mutate(native=ifelse(Native=="Yes",T,F)) %>%
  dplyr::select(-Native) %>%
# mutate col for conifer/deciduous
  mutate(group=ifelse(Group=="BD"|Group=="CD", 
                     "deciduous", "evergreen")) %>%
  dplyr::select(-Group) %>%
# mutate col for type, planting org
  mutate(type=ifelse(Org %in% c("FoTStreet", "BES Contractor"), "street",
                     ifelse(Org=="Park", "park", "yard"))) %>%
  mutate(org=ifelse(Org %in% c("FoTStreet", "FoTYard"), "fot",
                    ifelse(Org=="Park", "city", "contractor"))) %>%
  dplyr::select(-Org)
```

### Join with income data

According to [socialexplorer.com](https://www.socialexplorer.com/tables/ACS2015/R11672836), the median family income in the Portland area, in 2015-adjusted dollars, is $77,208. The HUD defines "low income" households as having 80% or less of median family income.

``` r
# left-join by FIPS
trees <- trees %>%
  left_join(medinc, by=c("FIPS"="FIPS"))

# mutate a col for income leevl
trees <- trees %>%
  mutate(inclevel = ifelse(income>.8*77208, "normal", "low"))
```

### Make a tree index

``` r
# get rid of cols we don't need
index_build <- trees %>%
  dplyr::select(name, group, size, native)
# mutate a whole bunch of numeric variables
index_build <- trees %>%
  mutate(s = ifelse(size=="S", 1,
                    ifelse(size=="M", 3, 5))) %>%
  mutate(n = ifelse(native, 1, 0)) %>%
  mutate(e = ifelse(group=="evergreen",2, 0)) %>%
# mutate index
  mutate(index = s + n + e)

# make a simple index of all the unique types of trees
tree_index <- index_build %>%
  dplyr::select(name,index) %>%
  group_by(name) %>%
  summarize(index=mean(index))

# left join index and tidy set
trees <- trees %>%
  left_join(tree_index,by=c("name"="name"))
```

The dataset `trees` is sufficient to perform analysis on planting trends. To study persistence, we need to join it with the 2010 tree survey data.

### Join with survey data

``` r
# pre-join tidying
# filter out trees that aren't street trees, or are planted after 2010, mutate origin
old_trees <- trees %>%
  filter(type=="street", year<2010) %>%
  mutate(Origin="planting")
# change address to uppercase
old_trees$address <- toupper(old_trees$address)

# survey data: unselect most columns, make a new col for origin, year
survey <- survey %>%
  dplyr::select(Date_Inventoried, Condition, Address, Scientific) %>%
  mutate(year = substr(Date_Inventoried, start=1, stop=4)) %>%
  mutate(Origin="survey") %>%
  dplyr::select(-Date_Inventoried)
names(survey) <- c("condition", "address","species","year","Origin")
```

``` r
# full join tree datasets by address, species
tree_persist <- old_trees %>%
  full_join(survey, by=c("address"="address","species"="species"))
```

    ## Warning: Column `address` joining character vector and factor, coercing
    ## into character vector

    ## Warning: Column `species` joining factors with different levels, coercing
    ## to character vector

``` r
glimpse(tree_persist)
```

    ## Observations: 239,949
    ## Variables: 19
    ## $ lon       <dbl> -122.6428, -122.6428, -122.6428, -122.6428, -122.694...
    ## $ lat       <dbl> 45.54973, 45.54973, 45.54973, 45.54973, 45.56888, 45...
    ## $ year.x    <int> 2008, 2008, 2008, 2008, 2005, 2005, 2007, 2008, 2008...
    ## $ address   <chr> "3704 NE 22ND AVE", "3704 NE 22ND AVE", "3704 NE 22N...
    ## $ name      <fct> elm, elm, elm, elm, elm, elm, elm, elm, elm, elm, el...
    ## $ species   <chr> "Ulmus spp.", "Ulmus spp.", "Ulmus spp.", "Ulmus spp...
    ## $ size      <fct> L, L, L, L, L, L, L, L, L, L, L, L, L, L, L, L, L, L...
    ## $ FIPS      <dbl> 41051003200, 41051003200, 41051003200, 41051003200, ...
    ## $ native    <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FAL...
    ## $ group     <chr> "deciduous", "deciduous", "deciduous", "deciduous", ...
    ## $ type      <chr> "street", "street", "street", "street", "street", "s...
    ## $ org       <chr> "fot", "fot", "fot", "fot", "fot", "fot", "fot", "fo...
    ## $ income    <int> 114896, 114896, 114896, 114896, 73709, 85000, 85000,...
    ## $ inclevel  <chr> "normal", "normal", "normal", "normal", "normal", "n...
    ## $ index     <dbl> 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5...
    ## $ Origin.x  <chr> "planting", "planting", "planting", "planting", "pla...
    ## $ condition <fct> Fair, Fair, Fair, Fair, NA, Good, Good, Fair, Good, ...
    ## $ year.y    <chr> "2016", "2016", "2016", "2016", NA, "2013", "2013", ...
    ## $ Origin.y  <chr> "survey", "survey", "survey", "survey", NA, "survey"...

``` r
write.csv(tree_persist,"~/emergency-response-time/data/tree_persist.csv",
          row.names=F)
```
