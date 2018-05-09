library(tidyverse)
library(plotly)
library(ggmap)
library(rgdal)
library(sp)
library(raster)
library(RColorBrewer)

persistence <- read.csv("~/emergency-response-time/data/tree_persist.csv")

setwd("~/emergency-response-time/data/tract-inc")
tracts <- readOGR(dsn=".", layer="tract_inc")

## load in road map to give context to maps
setwd("~/emergency-response-time/data-raw/maj-art")
roads <- readOGR(dsn=".",layer="maj_art")

roads <- roads %>%
  spTransform(CRS("+init=epsg:4326"))

roadf <- fortify(roads)
road_plot <- geom_path(data=roadf,aes(x=long,y=lat,group=id),col="white")

## load up income map
mf <- fortify(tracts, region="FIPS")
m <- tracts@data

map_plot <- geom_map(data = m, aes(map_id=FIPS, fill=income), 
                     map = mf)

## model results
pers_size <- persistence %>%
  filter(!is.na(persist)) %>%
  ggplot(aes(x=size,fill=persist)) +
  geom_bar(position="fill") +
  labs(title="Tree Persistence by Size",x="Size",y="Proportion",fill="Persisted")

pers_ever <- persistence %>%
  filter(!is.na(persist)) %>%
  ggplot(aes(x=group,fill=persist)) +
  geom_bar(position="fill") +
  labs(title="Persistence of Evergreen Trees",x="Type",y="Proportion",fill="Persisted")

pers_native <- persistence %>%
  filter(!is.na(persist)) %>%
  ggplot(aes(x=native,fill=persist)) +
  geom_bar(position="fill") +
  labs(title="Persistence of Native Trees",x="Native",y="Proportion",fill="Persisted")

pers_year <- persistence %>%
  filter(!is.na(persist)) %>%
  group_by(year) %>%
  mutate(p_prop=sum(persist)/n()) %>%
  ggplot(aes(x=year,y=p_prop)) +
  geom_line() +
  geom_point(shape=18) +
  ylim(0,1) +
  labs(title="Proportion of Persistent Trees by Year",x="Year",y="Proportion")

## map persistence
persistence_tidy <- persistence %>%
  filter(!is.na(persist))
pers_map <- ggplot() + map_plot + road_plot +
  geom_point(data=persistence_tidy, aes(x=lon,y=lat,color=persist, fill=income),
             shape=23) +
  scale_color_manual("Persisted",
                     values=c("orange","green"),
                     guide=guide_legend(override.aes=list(shape=c(19,19)))) +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605) +
  labs(title="Persistent PDX Trees",x="Longitude",y="Latitude")

### export images
ggsave("pers_year.png",pers_year, path="~/emergency-response-time/documents/visuals")
ggsave("pers_size.png",pers_size, path="~/emergency-response-time/documents/visuals")
ggsave("pers_native.png",pers_native, 
       path="~/emergency-response-time/documents/visuals")
ggsave("pers_evergreen.png",pers_ever, 
       path="~/emergency-response-time/documents/visuals", width=6, height=5)

ggsave("pers_map.png",pers_map, path="~/emergency-response-time/documents/visuals")



