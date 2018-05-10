A Study of Portland Street Tree Planting Trends
================
Miranda Rintoul and Lirui Jiao

-   [Introduction](#introduction)
-   [Data](#data)
    -   [Raw data](#raw-data)
    -   [Transformation](#transformation)
    -   [Sources](#sources)
-   [Analysis](#analysis)
    -   [Tree Planting Evaluation](#tree-planting-evaluation)
    -   [Planting and Income](#planting-and-income)
    -   [Tree Persistence](#tree-persistence)

Introduction
============

Our main area of interest is recent tree planting efforts by the City of Portland and the nonprofit Friends of Trees. We hope to see if the overall quality of planted trees has increased over time, and we are specifically interested in studying the planting efforts of low-income areas of Portland, defined as having a median income that is less than 80% of the greater Portland median income.

Secondly, we will study the persistence of Portland street trees by using a tree survey conducted from 2010-2016. We hope to discover which planted trees are still alive and in good condition, and which ones are no longer planted.

Data
====

Raw data
--------

We began with four datasets:

-   A database of tree plantings done by the City of Portland and Friends of trees. The data covers years 1989-2018 and contains information on the locations of the properties where these trees were planted.

-   A recent survey of street trees conducted by Portland Parks & Recreation. It covers the years 2010-2016 and describes the condition of all the trees surveyed.

-   A spatial dataset of Portland census tracts. We will be studying income on the census tract level, and we will use this data to make informative maps of the city.

-   A list of median income levels by census tract.

Transformation
--------------

First, we joined the planting data with the census tract data by location. This allowed us to figure out what tract, and therefore what income level, a tree belonged to.

Then, we built a "tree index" to more easily describe the overall quality of a tree. We are using the following index:

*Q* = *S* + *N* + *E*

where *Q* is the overall quality of a tree, *S* is the tree's size, *N* depends on whether a tree is native, and *S* depends on whether a tree is evergreen or deciduous. Large, native, and evergreen trees are considered to be the best types of trees.

This index is not perfect - some areas of the city do not have enough room for large trees. It is difficult to formulate one that would be accurate for the entire city.

After that, we created a new tree dataset by combining the planting and survey data. We joined these two datasets by address and by species, and noted whether or not each observation that existed in the planting dataset was also in the survey.

A more detailed description of the data transforming process can be found [here](https://github.com/ds-civic-data/pdx-tree-planting/blob/master/data-raw/data-tidy.md).

Sources
-------

Portland Parks & Recreation Urban Forestry. All Trees 3/2018 Species (accessed Apr 10 2018).

Portland Parks & Recreation Urban Forestry. Street Trees (accessed Apr 30 2018).

U.S. Census Bureau. Census Tracts 2010. Prepared by RLIS Discovery. <http://rlisdiscovery.oregonmetro.gov/?action=viewDetail&layerID=2588> (accessed Apr 10 2018).

U.S. Census Bureau. Median Family Income (In 2015 Inflation Adjusted Dollars), ACS 2015 (5-Year Estimates). Prepared by Social Explorer. <https://www.socialexplorer.com/tables/ACS2015_5yr/R11672838> (accessed Apr 20 2018).

Analysis
========

Tree Planting Evaluation
------------------------

Before studying how planting relates to income, we will assess the overall quality of planted trees. We'll do this by looking at the number of trees planted over time, then by studying proportional trends in the index, size, native, and evergreen variables.

<img src="visuals/num.png" width="500">

The number of trees planted has increased by quite a bit since the 1990s, but appears to have dropped off in the last 5 years.

<img src="visuals/index.png" width="500">

The overall quality of planted trees has increased over time. There are more excellent trees (value of 8) in recent years, but fewer good trees (index value of 5). The number of mediocre trees, with an index of 2-3, has remained fairly constant.

What tree qualities (size, native, evergreen) have shown the most improvement?

<img src="visuals/size.png" width="500">

In the period 1992-2005, there was an increase in large tree planting, and a decrease in small tree planting. However, this affect has apparently plateaued off in very recent years. It might be possible that the city is at carrying capacity for large trees - only a limited number of streets, parks, and yards have room for them.

<img src="visuals/native.png" width="500">

While small, the number of native plantings has improved over the last decade or so.

<img src="visuals/evergreen.png" width="500">

Similarly, though the proportion has been rising, evergreen trees make up only a small fraction of the planting data.

**Conclusions**

The quality of planted trees has been steadily increasing in the past few decades. There is a fairly even distribution of large, small, and medium trees, but only a small proportion of trees are native to Portland or evergreen.

Planting and Income
-------------------

We will attempt to address the issue of planting equity by building charts and maps. As before, we will focus on the index, size, native, and evergreen variables to assess tree quality.

The [HUD](https://www.hud.gov/program_offices/comm_planning/library/glossary/l#lowincome) defines "low income" as having a median income that is less than 80% of the median income for the region - for us, this is the greater Portland area. We will be studying income on the census tract level.

<img src="visuals/index_inc.png" height="400">

<img src="visuals/ind_scatter.png" width="500">

Initially, it seems that index remains relatively equal across low and mid-high income areas.

<img src="visuals/index_map.png" width="700">

Mapping trees by index, however, reveals some notable areas of interest (marked in white) that were not visible before. Two points, centered at approximately NE 15th Ave and NE Dekum St, and at NE Martin Luther King Jr Blvd and NE Prescott St (both in Northeast Portland), are areas with relatively low income and a concentration of poor quality trees. The areas surrounding NE 20th St and NE Siskiyou St, NE Glisan and NE Cesar Chavez Blvd, and SE Knapp St and SE 36th Ave, however, have relatively high income and a large number of good quality trees.

<img src="visuals/size_inc.png" height="400">

Over time, the proportions of small and large trees has remained fairly similar across different income areas.

<img src="visuals/size_map.png" width="700">

This map suggests that tree size might account for the disparity between the points of interest uncovered by the index map.

<img src="visuals/native_inc.png" width="500">

<img src="visuals/native_map.png" width="700">

<img src="visuals/evergreen_inc.png" width="500">

<img src="visuals/evergreen_map.png" width="700">

These four visuals suggest that, though somewhat sparse, evergreen and native trees are dispersed fairly evenly across the city.

**Conclusions**

In general, planting efforts by the city and Friends of Trees have been fairly equitable. There are a few notable areas with low median income and poor tree quality, which may have been caused by a disparity in tree size.

Tree Persistence
----------------

Our next goal is to figure out which trees last a long time after being planted. A tree is defined as "persistent" if it appears in the planting dataset before 2010, and also is listed in the 2010-2016 tree survey. We can provide some context for this question by looking at the proportion of trees from the planting dataset that have persisted long enough to be surveyed.

<img src="visuals/pers_year.png" width="500">

Unsurprisingly, older trees have lower persistence rates than newer trees.

We will attempt to predict whether or not a tree will persist by studying several qualities of a tree: its size, the income level of the area where it was planted, whether it is native, and whether it is evergreen or deciduous.

``` r
persistence <- persistence %>%
  filter(!is.na(persist))
persist_model <- lm(persist ~ size + native + group + inclevel, data=persistence)

summary(persist_model)
```

    ## 
    ## Call:
    ## lm(formula = persist ~ size + native + group + inclevel, data = persistence)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -0.3995 -0.2533 -0.1439 -0.1439  0.8937 
    ## 
    ## Coefficients:
    ##                   Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)       0.290841   0.008759  33.204  < 2e-16 ***
    ## sizeM            -0.007431   0.007903  -0.940    0.347    
    ## sizeS            -0.116835   0.007510 -15.558  < 2e-16 ***
    ## nativeTRUE        0.108605   0.013422   8.092 6.16e-16 ***
    ## groupevergreen   -0.263079   0.027507  -9.564  < 2e-16 ***
    ## inclevelmid-high -0.030071   0.006821  -4.408 1.05e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.401 on 23666 degrees of freedom
    ##   (4 observations deleted due to missingness)
    ## Multiple R-squared:  0.023,  Adjusted R-squared:  0.02279 
    ## F-statistic: 111.4 on 5 and 23666 DF,  p-value: < 2.2e-16

This initial modeling step suggests that small evergreen trees are less likely to persist. Native trees, however, are somewhat more likely to persist, and the effect income level has on persistence is extremely small. We can check these findings against visualizations of the same data.

<img src="visuals/pers_year.png" width="500">

Small trees have a noticeably smaller persistence rate compared to medium or large trees. This may be relevant to areas of the city that do not have room to plant large or medium trees.

<img src="visuals/pers_native.png" width="500">

Native trees have a somewhat higher persistance rate than non-native trees.

<img src="visuals/pers_evergreen.png" width="500">

Evergreen trees have a strikingly poor persistence rate when compared with their evergreen cousins. Given the fact that many pre-survey evergreens were planted after 2000, this shows that planted evergreen trees often do not last for more than a decade.

**Conclusions**

Large, deciduous trees have the best persistence rate, while small evergreen trees have the worst. There appears to be very little relationship between income and persistence.
