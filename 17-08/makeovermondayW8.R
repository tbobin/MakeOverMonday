

library(openxlsx)
library(tidyr)
library(dplyr)
library(ggplot2)
library(animation)
library(tweenr)


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

pot %>% ggplot(aes(y=`Yield.(100.kg/ha)`, x=Area.in.1000ha, color=Year)) + 
  geom_point() + 
  geom_line() +
  facet_wrap(~Country)


mydf <- function(yy){
  pot.df <- pot %>% filter(Year == yy) %>% arrange(Country) %>% 
    mutate(Land=as.factor(Country), Year=as.factor(Year)) %>% select(Land,Year,`Yield.(100.kg/ha)`,Area.in.1000ha)
  #pot.df$`Yield.(100.kg/ha)`[is.na(pot.df$`Yield.(100.kg/ha)`)] <- 0
  #pot.df$Area.in.1000ha[is.na(pot.df$Area.in.1000ha)] <- 0
  return(pot.df)
}

myplot <- function(i){
  g <- tween_pot %>% filter(i >= .frame) %>% 
    ggplot(aes(y=`Yield.(100.kg/ha)`, x=Area.in.1000ha, color=Year)) + 
    geom_point() + 
    xlim(0,400)+
    ylim(0,550)+
    facet_wrap(~Land)
  return(g)
}

#pot$Country[pot$Country == "Belgium"] <- "B"

plotingList <- lapply(seq(2010,2015), mydf)
tween_pot<-tween_states(plotingList,tweenlength=3,statelength=2, ease='cubic-in-out', nframes=60)
#tween_pot<-tween_elements(plotingList,time="Year",group="Land", ease='cubic-in-out', nframes=50)

myplot(1)

oopt = ani.options(interval = 0.1)
saveGIF({for (i in 1:max(tween_pot$.frame)) {
  g<-myplot(i)
  print(g)
  print(i)
  ani.pause()
}
},movie.name="pot.gif",ani.width = 840, ani.height =450)

