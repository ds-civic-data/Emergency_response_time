census-tract-tidy
================
Lirui Jiao

``` r
# read data
medianincome <- read.csv("~/emergency-response-time/data-raw/median-income.csv")
setwd("~/emergency-response-time/data-raw/census-tracts")
location <- readOGR(dsn = ".", layer ="tract2010")
```

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: ".", layer: "tract2010"
    ## with 491 features
    ## It has 16 fields

``` r
medianincome <- medianincome %>%
  select(Geo_FIPS, Geo_GEOID, Geo_NAME, Geo_QName, Geo_TRACT, SE_T061_001)
```

``` r
proj4string(location)
```

    ## [1] "+proj=lcc +lat_1=44.33333333333334 +lat_2=46 +lat_0=43.66666666666666 +lon_0=-120.5 +x_0=2500000 +y_0=0 +ellps=GRS80 +units=ft +no_defs"

``` r
location_proj <- location %>%
  spTransform(CRS("+init=epsg:4326")) %>%
  as.data.frame() %>%
  select(TRACT, TRACT_NO, FIPS) %>%
  mutate(numFIPS = as.numeric(FIPS))
```

``` r
census_tract <- full_join(medianincome, location_proj, by = c("Geo_FIPS" = "numFIPS")) 
```

``` r
setwd("~/emergency-response-time/data")
write.csv(census_tract, "census_tract.csv", row.names = F)
```
