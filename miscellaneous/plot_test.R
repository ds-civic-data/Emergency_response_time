library(tidyverse)

trees <- read.csv("~/emergency-response-time/data/fulltable_tidy.csv")

glimpse(trees)

# reorder income 
trees$inc_level <- factor(trees$inc_level, levels=c("normal","low","very_low"))


trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inc_level)) %>%
  group_by(year, inc_level) %>%
  mutate(ind=mean(index)) %>%
  ggplot(aes(x=year,y=ind)) +
  geom_line() +
  facet_grid(~ inc_level)

trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inc_level)) %>%
  group_by(year) %>%
  ggplot(aes(x=year)) +
  geom_bar() +
  facet_grid(~ inc_level)

trees %>%
  filter(year < 2018) %>%
  filter(!is.na(inc_level)) %>%
  ggplot(aes(x=year,fill=factor(index))) + 
  geom_bar(position="fill") +
  facet_grid(~ inc_level) +
  scale_fill_brewer(palette="Greens")
