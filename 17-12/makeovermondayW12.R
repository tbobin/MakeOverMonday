library(tidyverse)
library(lubridate)
library(ggplot2)


#setwd("/17-12")

ncaa_seeds <- read.csv("./17-12/NCAA Mens March Madness Historical Results.csv")

seeds <- ncaa_seeds %>% mutate(Date=date(strptime(Date, "%m/%d/%y")), year=year(Date))

participants <- data.frame(participant=unique(as.character(seeds$Winner)), stringsAsFactors=F)

participants <- participants %>% bind_rows(
  (seeds %>% mutate(participant=as.character(Loser)) %>% select(participant))
) %>% distinct()


winners <- seeds %>% select(-Losing.Score,-Loser, -Losing.Seed, -Overtime) %>% 
  mutate(win_Lose=1, Winner=as.character(Winner)) %>% rename(seed=Winning.Seed, team=Winner, score=Winning.Score)

losers <- seeds %>% select(-Winning.Seed, -Winner, -Winning.Score, -Overtime) %>% 
  mutate(win_Lose = 0, Loser=as.character(Loser)) %>% rename(seed=Losing.Seed, team=Loser, score=Losing.Score)

seed_flate <- winners %>% bind_rows(losers)

wins <- seed_flate %>% group_by(team, year, seed) %>% summarise(wins=sum(win_Lose)) %>% ungroup()

wins %>% ggplot(aes(x=seed, y=wins)) + 
  geom_point(aes(),position = "jitter") + 
  geom_smooth(method = "lm") +
  facet_wrap(~year)
#scale_y_continuous(breaks = c(1:16), limits = c(1,16))

wins %>% ggplot(aes(x=seed, y=wins,group=seed)) + 
  geom_boxplot()


seed_lm <- lm(seed~wins, data=wins[wins$year == 1985, ])
summary(seed_lm)