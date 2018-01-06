

library(openxlsx)
library(tidyverse)


data_df <- read.xlsx("17-45/LifeExpectancyAtBirth.xlsx", sheet = 1)


total <- data_df %>% 
  filter(Gender == "Total") %>% 
  group_by(Country.Name) %>% 
  arrange(Country.Name, Year) %>% 
  mutate(prior.Year = lag(Year), prior.Life.Expectancy = lag(Life.Expectancy)) %>% 
  mutate(change_in_Life_Exp_Total = Life.Expectancy - prior.Life.Expectancy ,
         change_in_Life_Exp_perc = change_in_Life_Exp_Total/prior.Life.Expectancy) %>% 
  ungroup()

country_count <- data_df %>% select(Country.Name) %>% distinct() %>% nrow
country_count <- data_df %>% filter(Gender == "Total") %>% select(Region, Country.Name) %>% 
  distinct() %>% group_by(Region) %>% summarise(n=n())

count_ECA <- data_df %>% filter(Region == "Europe & Central Asia") %>% select(Country.Name) %>% distinct() %>%  nrow()
qregion_count <- data_df %>% select(Region) %>% distinct() %>% nrow()

total %>% ggplot(aes(x=Year,y = Life.Expectancy, group = Country.Name, color = Country.Name)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  # scale_y_continuous(labels = scales::percent) +
  facet_wrap( ~Region, scales = "free")

total %>% ggplot(aes(x=Year,y = change_in_Life_Exp_perc, group = Country.Name, color = Country.Name)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap( ~Region, scales = "free")

total %>% filter(Region == "Europe & Central Asia") %>% ggplot(aes(x=Year,y = change_in_Life_Exp_perc)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap( ~Country.Name, scales = "free")

total %>% ggplot(aes(x=Year,y = change_in_Life_Exp_Total, group = Country.Name, color = Country.Name)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  # scale_y_continuous(labels = scales::percent) +
  facet_wrap( ~Region, scales = "free")

total %>% ggplot(aes(x=Year,y = change_in_Life_Exp_perc, group = Country.Name, color = Country.Name)) +
  geom_line() +
  theme_minimal() +
  theme(legend.position = "none") +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap( ~ Income.Group, scales = "free")


