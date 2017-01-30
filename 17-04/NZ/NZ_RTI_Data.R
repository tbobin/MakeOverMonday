
library(ggplot2)
library(ggmap)
library(choroplethr)
library(rgdal)
library(sp)

myLoc <- "New Zeland"

myLoc_lat_long <- geocode(myLoc)

myMap <- try(get_map(location = myLoc, source = "google", zoom = 5))
# myMap <- get_openstreetmap(bbox = myLoc_lat_long)
ggmap(myMap)

setwd("D:\\Entwurf\\R\\MakeOverMonday\\NZ")

shapData <- readOGR(".", layer = "ad2")
shapData <- readRDS("NZL_adm2.rds")
ggplot(data = shapData, aes(x = long, y = lat,group = group))+
  theme_minimal()+
  geom_polygon(color = "white") + 
  coord_map(xlim = c(165, 180), ylim = c(-32, -48))
