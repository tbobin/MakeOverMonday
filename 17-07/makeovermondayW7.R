
library(openxlsx)
library(tidyr)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(scales)
library(gridExtra)

mom07_df_ori <- read.xlsx("./17-07/Valentines Day Spending.xlsx", sheet = 1)

color_palette <- c("#ff0066", "#ffb1d0", "#51656e", "#6e8a95",  "#4c4642", "#87847b", "#ccc3ba", "#75b8d1", "#2d543d")

mom07_df <- mom07_df_ori %>% 
  rename(spend_on = `How.much.money.do.you.plan.to.spend.on.Valentine's.Day.gifts.for`)  %>% 
  gather(key="year", value="value", -Category, -spend_on, -Metric) %>% 
  spread(Metric, value)

g <- mom07_df %>% filter(Category == "People") %>% ggplot(aes(x=year, y=`Net Average Spend`, fill=spend_on, group=spend_on)) +
  scale_fill_manual(name="spend on", values=color_palette)

g1 <- g + geom_area() + 
  scale_y_continuous( labels = dollar_format(prefix = "", suffix = "$")) +
  labs(title="How much do Americans celebrating Valentin's day spend on",
      caption="source: National Retail Federation's Valentine's Day Spending Survey 2016") +
  theme_ipsum_rc(grid="XY") + theme(legend.position = "bottom")
  
  

g2 <- g + 
  geom_bar(position = "fill", stat = "identity") + 
  scale_y_continuous( labels = percent) +
  labs(title="How is the share of the different categories",
       caption="source: National Retail Federation's Valentine's Day Spending Survey 2016") +
  theme_ipsum_rc(grid="Y") + theme(legend.position = "bottom")


g1
g2

gridExtra::grid.arrange(g1, g2, ncol=2)


#ff0066
#ffb1d0
#51656e
#6e8a95
#4c4642
#87847b
#ccc3ba