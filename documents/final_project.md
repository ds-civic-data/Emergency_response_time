A Study of Portland Street Tree Planting Trends
================
Miranda Rintoul and Lirui Jiao

-   [Introduction](#introduction)
-   [Data](#data)
    -   [Raw data](#raw-data)
    -   [Transformation](#transformation)
-   [Analysis](#analysis)

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

-   A recent survey of street trees conducted by ?????. It covers the years 2010-2016 and describes the condition of all the trees surveyed.

-   A spatial dataset of Portland census tracts. We will be studying income on the census tract level, and we will use this data to make informative maps of the city.

-   A list of median income levels by census tract.

Transformation
--------------

First, we joined the planting data with the census tract data by location. This allowed us to figure out what tract, and therefore what income level, a tree belonged to.

Then, we built a "tree index" to more easily describe the overall quality of a tree. We are using the following index:

*Q* = *S* + *N* + *E*

where *Q* is the overall quality of a tree, *S* is the tree's size, *N* depends on whether a tree is native, and *S* depends on whether a tree is evergreen or deciduous. Large, native, and evergreen trees are considered to be the best types of trees.

After that, we created a new tree dataset by combining the planting and survey data. We joined these two datasets by address and by species, and noted whether or not each observation that existed in the planting dataset was also in the survey.

A more detailed description of the data transforming process can be found [here](https://github.com/ds-civic-data/pdx-tree-planting/blob/master/data-raw/data-tidy.md).

Analysis
========
