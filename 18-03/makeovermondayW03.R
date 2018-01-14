

library(tidyverse)
library(data.world)
library(extrafont)
#font_import()
#loadfonts(device="win") 

ds <-  "https://data.world/makeovermonday/2018-w-3-u-s-household-income-distribution-by-state"

sql_string <- data.world::qry_sql("Select * from income")

mm_1803_df <- data.world::query(sql_string, dataset = ds)

# Einkommensschere?


