
library(RSocrata)
library(httr)
library(jsonlite)



qurl_base <- "https://data.cityofchicago.org/resource/wrvz-psew.json?"
qurl_limit <- "$limit=5"
qurl_where <- "$where=trip_start_timestamp between '2016-01-01T00:00:01' and '2016-01-02T00:00:00'"


qurl_count <- "$select=count(trip_id)"


queryurl <- paste0(qurl_base,qurl_count,"&",qurl_where)
queryurl <- paste0(qurl_base,qurl_limit,"&",qurl_where)

valid_url <- validateUrl(queryurl, AppToken)

GET(valid_url)

a <- read_json(GET(valid_url))

df <- read.socrata(url = queryurl, 
                   email= EMAIL, 
                   password = PWD,
                   app_token = AppToken)

