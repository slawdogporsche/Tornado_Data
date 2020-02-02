## Tornado Visualization ## 

## Setup ## 

library(sf)
library(tidyverse)
library(maps)

  setwd("C:/Users/Ben/Desktop/Tornado_Data/1950-2018-torn-aspath")

## Data ##

t_data <- st_read("1950-2018-torn-aspath.shp")

maps <- map_data("world") %>%
  as_tibble() %>%
  filter(region == "USA")

## Validation ## 

st_crs(t_data)

st_bbox(t_data)

## Visualization ## 
## Have to somehow use geometry field to show change over time 
t_data %>%
  ggplot() +
  geom_polygon(data = maps, aes(x = long, y=lat, group = group)) +
  geom_point(aes(x=slon, y= slat, color = mag))  + 
  xlim(-130,-60) + 
  ylim(23,50)
  
  
  
  
  

