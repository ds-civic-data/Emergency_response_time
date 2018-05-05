library(tidyverse)
library(dplyr)

trees <- read.csv("~/emergency-response-time/data/trees.csv")


trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(size,levels=c("S","M","L")))) + 
  geom_bar(position="fill") +
  scale_fill_brewer(palette="YlGnBu") +
  labs(title="Planting Proportions by Size",x="Year",y="Percent of Total Plantings",
       fill="Size")

trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(native,levels=c("FALSE", "TRUE")))) + 
  geom_bar(position="fill") +
  scale_fill_brewer(palette="GnBu") +
  labs(title="Planting Proportions by Native",x="Year",y="Percent of Native Species",
       fill="Native")


trees %>%
  filter(year < 2018) %>%
  ggplot(aes(x=year,fill=factor(group,levels=c("deciduous", "evergreen")))) + 
  geom_bar(position="fill") +
  scale_fill_manual(labels = c("Deciduous","Evergreen"),
                    values=c("yellow2","springgreen3")) +
  labs(title="Evergreen Plantings",x="Year",y="Percent of Total Plantings", fill = "Group")


