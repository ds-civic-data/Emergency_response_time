library(tidyverse)
library(ggmap)
library(rgdal)
library(sp)
library(raster)
library(RColorBrewer)

setwd("~/emergency-response-time/data/tract-inc")
tracts <- readOGR(dsn=".", layer="tract_inc")

trees <- read.csv("~/emergency-response-time/data/trees.csv")

mf <- fortify(tracts, region="FIPS")
m <- tracts@data

xlims <- c(-122.78, -122.49)
ylims <- c(45.45, 45.62)

ggplot() + geom_map(data = m, aes(map_id=FIPS, fill=income), 
                     map = mf) +
  geom_point(data=trees, aes(x=lon,y=lat,color=index,fill=income),shape=43) +
  scale_color_gradient(low="red",high="green") +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605)

