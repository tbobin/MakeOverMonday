

library(tidyverse)
library(data.world)
library(scales)


ds <-  "https://data.world/makeovermonday/2018-w-1-u-s-per-capita-consumption-of-poultry-livestock"

sql_string <- data.world::qry_sql("Select * from poultry_and_livestock_consumption")

mm_1801_df <- data.world::query(sql_string, dataset = ds)

mm_data <- mm_1801_df %>% 
  filter(actual_forecast == "Actual") %>% 
  select(year, beef, pork, total_chicken) %>% 
  rename(chicken = total_chicken) %>% 
  gather(beef, pork, chicken, key="meat", value = "pounds")

mm_data <- mm_data %>% mutate(meat = factor(meat, levels = c("chicken","beef","pork"), ordered = T))

mm_data_total <- mm_1801_df %>% 
  filter(actual_forecast == "Actual") %>% 
  mutate(Total = (total_chicken + pork + beef)) %>% 
  select(year, Total)

mm_data_total <- mm_data_total %>% 
  mutate(Total_ratio = Total/mm_data_total$Total[mm_data_total$year == min(mm_data_total$year)])
  
mm_data_total %>% ggplot(aes(x = year, y = Total_ratio)) +
  geom_line() +
  coord_cartesian(ylim = c(0, 1.35)) +
  scale_y_continuous(labels = percent) + 
  theme_minimal() +
  labs(y = "Total consumption comp. to 1960", x = "Year")

mm_data %>% ggplot(aes(x=year, y = pounds, fill = meat)) +
  geom_area(position = "fill") +
  scale_fill_manual(values = c(chicken = "#e54c0b", pork = "#770b70", beef = "#770b1b")) +
  scale_y_continuous(labels = percent) +
  theme_minimal() +
  labs(y = "Ratio", x = "Year")


