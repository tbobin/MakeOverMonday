
library(RSocrata)
library(rgdal)
library(sp)
library(httr)
library(jsonlite)

# download shape files from 
# https://data.cityofchicago.org/Facilities-Geographic-Boundaries/Boundaries-Community-Areas-current-/cauq-8yn6 
# needed for mapping the area_number to community name 
#
# load shape file
chicagoShp <- readOGR(dsn="./17-06/Boundaries", layer = "geo_export")
# convert to data frame
chicagoShp_df <- data.frame(chicagoShp)

# parts for bilding the query
qurl_base <- "https://data.cityofchicago.org/resource/wrvz-psew.csv?"
qurl_limit <- "$limit="
qurl_offset <- "$offset="
qurl_where <- "$where=trip_start_timestamp between '2016-03-01T00:00:00' and '2016-04-01T00:00:00'"
qurl_count <- "$select=count(trip_id)"


queryurl_count <- paste0(qurl_base,qurl_count,"&",qurl_where,"&$order=Count_trip_id")

trips_count <- read.socrata(url=queryurl_count, email = EMAIL, password = PWD, app_token = AppToken)

# work around due to problems with the RSocrata library
# building the query
queryurl <- paste0(qurl_base,qurl_limit,trips_count$count_trip_id,"&",qurl_where)
valid_url <- validateUrl(queryurl, AppToken)
a <- GET(valid_url)


#  queryurl <- paste0(qurl_base,qurl_limit,"&",qurl_offset,page_offset,"&",qurl_where)
# queryurl <- paste0(qurl_base,qurl_where)
# print(queryurl)
# # connection to the open data portal of chicago and quering the data
# df <- read.socrata(url = queryurl, 
#                    email= EMAIL, 
#                    password = PWD,
#                    app_token = AppToken)
# 

df2 <- read.csv(textConnection(httr::content(a, 
                                             as = "text", 
                                             type = "text/csv", 
                                             encoding = "utf-8")), 
                stringsAsFactors = FALSE)

saveRDS(df, file = "./17-06/chicagoTaxiRides.RDS")

# alternative load data from RDS file 
df <- readRDS(file = "./17-06/chicagoTaxiRides.RDS")

