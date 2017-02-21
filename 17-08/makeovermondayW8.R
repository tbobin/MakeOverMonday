

library(openxlsx)
library(tidyr)
library(dplyr)
library(ggplot2)

W8file <- "Potato crop yields and selling prices.xlsx"
path <- "./17-08"

setwd("./17-08")

pot_price_ori <- read.xlsx(W8file, sheet = 1)
pot_yield_ori <- read.xlsx(W8file, sheet = 2)

pot <- pot_yield_ori %>% left_join(pot_price_ori) %>% filter(Year<2016, !grepl("Union", Country))
pot$Country[grepl("Kosovo", pot$Country)] <- "Kosovo"
pot$Country[grepl("Macedonia", pot$Country)] <- "Macedonia"

pot %>% ggplot(aes(x=`Yield.(100.kg/ha)`, y=EUR.per.100.kg, color=Country)) + geom_point() + facet_wrap(~Year)


pot %>% ggplot(aes(x=Year, y=`Yield.(100.kg/ha)`, group=Country, color=Country)) + 
  geom_line() #+ 
  # theme(legend.position = "bottom")

pot %>% ggplot(aes(y=`Yield.(100.kg/ha)`, x=Area.in.1000ha, color=Country)) + geom_point() + facet_wrap(~Year)


