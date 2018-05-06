library(tidyverse)
library(dplyr)

trees <- read.csv("~/emergency-response-time/data/trees.csv")

ind <- trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(index))) + 
  geom_bar(position="fill") +
  scale_fill_brewer(palette="RdYlGn") +
  labs(title="Plantings by Tree Index",x="Year",y="Percent of Total Plantings",
       fill="Index Value")

size <- trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(size,levels=c("S","M","L")))) + 
  geom_bar(position="fill") +
  scale_fill_brewer(palette="YlGnBu") +
  labs(title="Planting Proportions by Size",x="Year",y="Percent of Total Plantings",
       fill="Size")

native <- trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(native,levels=c("FALSE", "TRUE")))) + 
  geom_bar(position="fill") +
  scale_fill_manual(labels = c("Non-native","Native"),
                    values=c("greenyellow","springgreen3")) +
  labs(title="Native Plantings",x="Year",y="Percent of Native Species",
       fill="Type")


ever <- trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(group,levels=c("deciduous", "evergreen")))) + 
  geom_bar(position="fill") +
  scale_fill_manual(labels = c("Deciduous","Evergreen"),
                    values=c("greenyellow","springgreen3")) +
  labs(title="Evergreen Plantings",x="Year",y="Percent of Total Plantings",
       fill="Type")

# export plots
ggsave("index.png",ind, path="~/emergency-response-time/documents/visuals")
ggsave("size.png",size, path="~/emergency-response-time/documents/visuals")
ggsave("native.png",native, path="~/emergency-response-time/documents/visuals")
ggsave("evergreen.png",ever, path="~/emergency-response-time/documents/visuals")




