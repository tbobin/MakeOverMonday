
library(openxlsx)
library(ggplot2)
library(dplyr)
library(tidyr)
library(scales)


# setwd("D:\\Entwurf\\R\\MakeOverMonday\\17-05")

# https://1drv.ms/x/s!AhZVJtXF2-tD1V-onU3koiSkEPvC
# http://www.makeovermonday.co.uk/data/

mom_data_ori <- read.xlsx("./17-05/Employment Growth in G-7 Countries.xlsx", sheet = 1)

srt <- mom_data_ori %>% 
  arrange(Employment.Share) %>% 
  mutate(Country = factor(Country)) %>% 
  select(Country)
srt <- factor(srt$Country)

mom_data <- mom_data_ori %>% 
  arrange(Employment.Share) %>% 
  mutate(Country = factor(Country), NetEmpGrowth = -Net.Employment.Growth.Share, EmpShare= Employment.Share) %>%
  select(-Net.Employment.Growth.Share, -Employment.Share) %>% 
  gather(NetEmpGrowth, EmpShare, key="cat", value="growth",convert=TRUE) %>% 
  mutate(lbl_pos = ifelse(cat == "EmpShare", growth + 0.1, growth - 0.1), 
         lbl = ifelse(cat == "EmpShare", paste0((growth*100),"%"), paste0((growth*-100),"%"))) 

brks <- seq(-0.6, 0.6,0.1)
lbls <- c(as.character(seq(60, 0, -10)), as.character(seq(10, 60, 10)))
lbls <- c(paste0(seq(60,0,-10),"%"),paste0(seq(10,60,10),"%"))

g <- mom_data %>% ggplot(aes(x=Country, y=growth, fill=cat ))
g <- g + geom_bar(stat="identity", width = 0.2) +
  scale_y_continuous(breaks = brks,
                     labels = lbls,
                     limits = c(-0.7,0.7)) + 
  scale_x_discrete(limits=srt) +
  coord_flip()
g <- g + geom_label(aes(y=lbl_pos, label=lbl), vjust = 0)
g <- g + ggtitle("Employee Growth in G-7 Countries")
g <- g + labs(title = "Employee Growth in G-7 Countries 2010", 
              subtitle = "2010 Q1 - 2016 Q3",
              caption = "Componenets may not sum to total due to rounding\n Source: Org for Economics") 
g

ggsave("./17-05/MakeOverMondayW5.png", width = 15, height = 10)
