

library(tidyverse)
library(data.world)
library(extrafont)
#font_import()
#loadfonts(device="win") 

ds <-  "https://data.world/makeovermonday/2018-w-3-u-s-household-income-distribution-by-state"

sql_string <- data.world::qry_sql("Select * from income")

mm_1803_df <- data.world::query(sql_string, dataset = ds)

# Einkommensschere?

unique(mm_1803_df$income_level)

mm_1803 <- mm_1803_df %>% 
  mutate(income_level_1 = str_replace_all(income_level, "\\$|,", "" )) %>% 
  separate(income_level_1, into = c("from", "to"), sep = "[^[:digit:]]+") %>% 
  mutate(from = as.numeric(str_replace(from, "^$", "0")), to = as.numeric(str_replace(to,"^$", "Inf"))) %>% 
  mutate(classe = ifelse(to<150000,ifelse(to<50000,"<50k", "50k - 150k"), ">150k"))


# 0 499999
# 50 149
# 150 Inf

mm_1803_agg <- mm_1803 %>% 
  group_by(year, classe) %>% 
  summarise(number_of_households = sum(number_of_households)) %>% 
  ungroup() %>% 
  group_by(year) %>% 
  mutate(percent_of_total = number_of_households/sum(number_of_households))



mm_1803_agg %>% ggplot(aes(x = year, y = percent_of_total, color = classe)) +
  geom_line() +
  #scale_y_continuous(limits = c(0,1)) +
  theme_minimal()

ggsave("18-03/mm1803.png")


