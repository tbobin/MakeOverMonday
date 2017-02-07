
library(RSocrata)

AppToken <- "JCVQmBHeUpEHN6j8CJycdJok2"


queryurl <- "https://data.cityofchicago.org/resource/wrvz-psew.csv?$limit=10000&$where=trip_start_timestamp between '2016-01-01T12:00:01' and '2016-01-01T13:00:00'"

validateUrl(queryurl2, AppToken)

df <- read.socrata(url = queryurl2, email= EMAIL, password = PWD,
                   app_token = AppToken)

