

library(openxlsx)
library(tidyverse)
library(viridis)


setwd("./17-39")

momdata <- read.xlsx("Restricted Dietary Requirements Around The Globe.xlsx", sheet = 1)


plot <- momdata %>% ggplot(aes(x = Diet, y = Followers, fill = Region)) + 
  geom_col() + 
  scale_fill_viridis( discrete = TRUE, option = "C") + 
  theme_minimal() +
  facet_wrap(~Region)


plot

