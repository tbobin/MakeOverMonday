

library(tidyverse)
library(openxlsx)
library(scales)

setwd("./17-40")

# loading the G7 groth data for MM week 40 
G7_GDP_groth <- read.xlsx("G7 Quarterly GDP Growth.xlsx", detectDates = T)


G7_GDP_AVR_per_Q <- G7_GDP_groth %>% 
  mutate(Percentage.change.from.previous.period = Percentage.change.from.previous.period/100) %>% 
  group_by(Country,Quarter) %>% summarise(avr = mean(Percentage.change.from.previous.period))

G7_GDP_groth_all <- G7_GDP_groth %>% 
  rename(Date = `Date.(start.of.quarter)`, `GDP change`=Percentage.change.from.previous.period) %>% 
  mutate(`GDP change` = `GDP change`/100)

G7_GDP_max_Q <- G7_GDP_AVR_per_Q %>% 
  ungroup() %>% 
  group_by(Quarter) %>% 
  filter(avr == max(avr)) %>% 
  rename(max_avr = avr, Country_max = Country)

G7_GDP_min_Q <- G7_GDP_AVR_per_Q %>% 
  ungroup() %>% 
  group_by(Quarter) %>% 
  filter(avr == min(avr)) %>% 
  rename(min_avr = avr, Country_min = Country)

G7_GDP_groth_all <- G7_GDP_groth_all %>% 
  left_join(G7_GDP_max_Q) %>% 
  left_join(G7_GDP_min_Q)


p <- G7_GDP_groth_all %>% filter(Country != "GBR") %>% 
  ggplot(aes(x=Date, y=`GDP change`, fill=Country)) + 
  geom_line(color = "darkgray") +
  geom_line(data = (
    G7_GDP_groth_all %>% filter(Country == "GBR")
  ), color = "red") +
  geom_hline(aes(yintercept = max_avr), G7_GDP_max_Q, colour = "blue") +
  geom_hline(aes(yintercept = avr), (filter(G7_GDP_AVR_per_Q, Country == "GBR")), colour = "red") +
  geom_hline(aes(yintercept = min_avr), G7_GDP_min_Q, colour = "blue") +
  theme_minimal() + 
  theme(panel.grid = element_blank()) +
  scale_y_continuous(labels = percent) +
  facet_grid(. ~ Quarter) 

p




