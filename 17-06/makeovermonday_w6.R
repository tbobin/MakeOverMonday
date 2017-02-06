
library(RSocrata)

AppToken <- "JCVQmBHeUpEHN6j8CJycdJok2"


queryurl <- "https://data.cityofchicago.org/resource/wrvz-psew.json?
  $where=trip_start_timestamp between '2016-01-01T00:00:01' and '2016-01-01T12:00:00'&$limit=10000"

df <- read.socrata(url = queryurl,
                   app_token = AppToken)

