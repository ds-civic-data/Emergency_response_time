library(tidyverse)
library(dplyr)

trees <- read.csv("~/emergency-response-time/data/trees.csv")

trees %>%
  filter(year<2018) %>%
  mutate()
  ggplot(aes(x=year)) +
  geom_bar() +
  facet_wrap(~ size)
