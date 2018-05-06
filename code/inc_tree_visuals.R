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

map_plot <- geom_map(data = m, aes(map_id=FIPS, fill=income), 
                     map = mf)

xlims <- c(-122.78, -122.49)
ylims <- c(45.45, 45.62)

interest_lon <- c(-122.66,-122.645,-122.65,-122.625,-122.625)
interest_lat <- c(45.553,45.545,45.57,45.525,45.47)

pts_interest <- as.data.frame(cbind(interest_lon,interest_lat))

### index

ind_inc <- trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inclevel)) %>%
  ggplot(aes(x=year,fill=factor(index))) + 
  geom_bar(position="fill") +
  facet_grid(~ inclevel) +
  scale_fill_brewer(palette="RdYlGn") +
  labs(title="Plantings by Tree Index, Low vs Normal Income",
       x="Year",y="Percent of Total Plantings",
       fill="Index Value")

ind_map <- ggplot() + map_plot +
  geom_point(data=trees, aes(x=lon,y=lat,color=index,fill=income),shape=23) +
  scale_color_gradient("Index",low="red",high="chartreuse") +
  geom_point(data=pts_interest,aes(x=interest_lon,y=interest_lat),color="white",
             shape=19) +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605) +
  labs(title="PDX Trees by Index",x="Longitude",y="Latitude")

### size

size_inc <- trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inclevel)) %>%
  ggplot(aes(x=year,fill=factor(size,levels=c("S","M","L")))) + 
  geom_bar(position="fill") +
  facet_grid(~ inclevel) +
  scale_fill_brewer(palette="YlGnBu") +
  labs(title="Planting Proportions by Size, Low vs Normal Income",
       x="Year",y="Percent of Total Plantings",
       fill="Size")

size_map <- ggplot() + map_plot +
  geom_point(data=trees, aes(x=lon,y=lat,color=factor(size,levels=c("S","M","L")),
                             fill=income),
             shape=23) +
  scale_color_manual("Size",
                     values=c("orange","yellow","green"),
                     guide=guide_legend(override.aes=list(shape=c(19,19,19)))) +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605) +
  labs(title="PDX Trees by Size",x="Longitude",y="Latitude")

### native

native_inc <- trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inclevel)) %>%
  ggplot(aes(x=year,fill=factor(native,levels=c("FALSE", "TRUE")))) + 
  geom_bar(position="fill") +
  facet_grid(~ inclevel) +
  scale_fill_manual(labels = c("Non-native","Native"),
                    values=c("greenyellow","springgreen3")) +
  labs(title="Native Plantings, Low vs Normal Income"
       ,x="Year",y="Percent of Native Species",
       fill="Type")

native_map <- ggplot() + map_plot +
  geom_point(data=trees, aes(x=lon,y=lat,
                             color=factor(native,levels=c("FALSE", "TRUE")),
                             fill=income),
             shape=23) +
  scale_color_manual("Type",
                     values=c("orange","green"),
                     labels=c("Non-native","Native"),
                     guide=guide_legend(override.aes=list(shape=c(19,19)))) +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605) +
  labs(title="Native PDX Trees",x="Longitude",y="Latitude")

### evergreen

ever_inc <- trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inclevel)) %>%
  ggplot(aes(x=year,fill=factor(group,levels=c("deciduous", "evergreen")))) + 
  geom_bar(position="fill") +
  facet_grid(~ inclevel) +
  scale_fill_manual(labels = c("Deciduous","Evergreen"),
                    values=c("greenyellow","springgreen3")) +
  labs(title="Evergreen Plantings, Low vs Normal Income",
       x="Year",y="Percent of Total Plantings",
       fill="Type")

ever_map <- ggplot() + map_plot +
  geom_point(data=trees, aes(x=lon,y=lat,
                             color=factor(group,levels=c("deciduous", "evergreen")),
                             fill=income),
             shape=23) +
  scale_color_manual("Type",
                     values=c("orange","green"),
                     labels=c("Deciduous","Evergreen"),
                     guide=guide_legend(override.aes=list(shape=c(19,19)))) +
  xlim(-122.75, -122.495) +
  ylim(45.46, 45.605) +
  labs(title="Evergreen PDX Trees",x="Longitude",y="Latitude")


### export maps
ggsave("index_inc.png",ind_inc, path="~/emergency-response-time/documents/visuals")
ggsave("index_map.png",ind_map, path="~/emergency-response-time/documents/visuals")

ggsave("size_inc.png",size_inc, path="~/emergency-response-time/documents/visuals")
ggsave("size_map.png",size_map, path="~/emergency-response-time/documents/visuals")

ggsave("native_inc.png",native_inc, 
      path="~/emergency-response-time/documents/visuals")
ggsave("native_map.png",native_map, 
      path="~/emergency-response-time/documents/visuals")

ggsave("evergreen_inc.png",ever_inc, 
      path="~/emergency-response-time/documents/visuals")
ggsave("evergreen_map.png",ever_map,
      path="~/emergency-response-time/documents/visuals")



