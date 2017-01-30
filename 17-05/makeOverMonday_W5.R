
library(openxlsx)
library(ggplot2)
library(dplyr)
library(tidyr)


# setwd("D:\\Entwurf\\R\\MakeOverMonday\\17-05")

# https://1drv.ms/x/s!AhZVJtXF2-tD1V-onU3koiSkEPvC
mom_data_ori <- read.xlsx("./17-05/Employment Growth in G-7 Countries.xlsx", sheet = 1)

mom_data <- mom_data_ori %>% 
  arrange(Employment.Share) %>% 
  mutate(NetEmp = -Net.Employment.Growth.Share, EmpShare= Employment.Share) %>%
  select(-Net.Employment.Growth.Share, -Employment.Share) %>% 
  gather(NetEmp, EmpShare, key="cat", value="growth",convert=TRUE)

brks <- seq(-0.6, 0.6,0.1)
lbls <- c(as.character(seq(0.6, 0, -0.1)), as.character(seq(0.1, 0.6, 0.1)))

g <- mom_data %>% ggplot(aes(x=Country, y=growth, fill=cat ))
g <- g + geom_bar(stat="identity", width = 0.2) +
  scale_y_continuous(breaks = brks,
                     labels = lbls) + 
  coord_flip()
# g <- g + geom_label(aes(label=groth), position = "dodge")
g

