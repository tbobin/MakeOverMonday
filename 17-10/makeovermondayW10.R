

library(openxlsx)
library(tidyverse)
library(stringr)
library(GGally)
library(viridis)




SB_Gamer <- read.xlsx("./17-10/Top 500 YouTube Games Channels.xlsx", sheet = 1)


Rating_level <- c("A+","A","A-","B+","B","B-","C+","C","C-","D+","D","D-")

SB_Gamer <- SB_Gamer %>% mutate(Rating = factor(Rating, levels=Rating_level, ordered = TRUE), 
                                BaseRating = factor(str_extract(Rating, "\\b[A-Z]")))


SB_Gamer_df <- select(SB_Gamer, -Rank, -User)


#pairs(SB_Gamer_df, col=SB_Gamer_df$BaseRating, upper.panel = NULL)
#legend(5,5, bty="n", legend = LETTERS[1:4], col = C("black","red","green", "blue"))

#ggpairs(SB_Gamer_df, ggplot2::aes(colour=Rating))

SB_Gamer %>% ggplot(aes(x=Rating))+geom_histogram(stat = "count")
SB_Gamer %>% ggplot(aes(x=Subscribers, y=Video.Views, color=SB.Score))+geom_point()+facet_wrap(~Rating)
SB_Gamer %>% filter(Rating<"B-") %>% 
  ggplot(aes(x=Subscribers, y=Video.Views, color=SB.Score))+geom_point()+facet_wrap(~Rating)+
  scale_color_viridis()

SB_Gamer %>% ggplot(aes(x=Rating, y=Video.Views)) + geom_point()

min(SB_Gamer$Video.Views)

m <- nls(Video.Views~1/Rating+285000000, data = SB_Gamer)

