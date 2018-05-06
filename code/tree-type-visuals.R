library(tidyverse)
library(dplyr)

trees <- read.csv("~/emergency-response-time/data/trees.csv")

num <- trees %>%
  filter(year < 2018) %>%
  group_by(year) %>%
  ggplot(aes(x=year)) +
  geom_bar() +
  labs(title="Trees Planted over Time",x="Year",y="Trees Planted")

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
  group_by(year) %>%
  mutate(n_prop = sum(native)/n()) %>%
  ggplot(aes(x=year,y=n_prop)) +
  geom_line() +
  geom_point(shape=18) +
  ylim(0,1) +
  labs(title="Native Plantings",x="Year",y="Native Proportion")

ever <- trees %>%
  filter(year < 2018) %>%
  group_by(year) %>%
  mutate(e_prop = sum(group=="evergreen")/n()) %>%
  ggplot(aes(x=year,y=e_prop)) +
  geom_line() +
  geom_point(shape=18) +
  ylim(0,1) +
  labs(title="Evergreen Plantings",x="Year",y="Evergreen Proportion")

# export plots
ggsave("num.png",num,path="~/emergency-response-time/documents/visuals")
ggsave("index.png",ind, path="~/emergency-response-time/documents/visuals")
ggsave("size.png",size, path="~/emergency-response-time/documents/visuals")
ggsave("native.png",native, path="~/emergency-response-time/documents/visuals")
ggsave("evergreen.png",ever, path="~/emergency-response-time/documents/visuals")




