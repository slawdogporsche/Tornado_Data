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
t_data[1:50,] %>%
  ggplot() +
   geom_point(aes(x=slon, y= slat, color = "blue")) +
  coord_fixed(1.3) +
  geom_polygon(data = maps, aes(x = long, y=lat, group = group,  fill = region)) +
  
  
  
  
  

