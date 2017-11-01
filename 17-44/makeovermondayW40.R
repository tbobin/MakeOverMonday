
library(openxlsx)
library(tidyverse)
library(timetk)


mm44Data <- read.xlsx("17-44/Public Holidays around the world (final).xlsx", detectDates = TRUE) 

mm44Data <- timetk::tk_augment_timeseries_signature(mm44Data)

bankHoliday_region <- mm44Data %>% filter(Holiday.Type == "Bank holiday") %>% group_by(Region) %>% summarise(count = n())

bankHoliday_country <- mm44Data %>% filter(Holiday.Type == "Bank holiday") %>% group_by(Country) %>% summarise(count = n())

Holiday_day_count <- mm44Data %>% group_by(week, wday, wday.lbl, month.lbl)  %>%  dplyr::summarise(cnt = n()) %>% ungroup()


Holiday_day_count %>% ggplot(aes(x = week, y = wday.lbl)) + 
  geom_tile(aes(fill = cnt)) +
  scale_fill_gradient2(low="blue", mid = "yellow", high="green", midpoint = 125) +
  facet_grid( ~ month.lbl, scales = "free_x") +
  theme_bw()

Holiday_day_count %>% ggplot(aes(cnt)) + geom_histogram(bins = 100)

summary(Holiday_day_count)

