## Tornado Visualization ## 

## Setup ## 

library(sf)
library(tidyverse)

setwd("C:/Users/Ben/Desktop/Tornado_Data/1950-2018-torn-aspath")

## Data ##

t_data <- st_read("1950-2018-torn-aspath.shp")

## Validation ## 

st_crs(t_data)

st_bbox(t_data)

## Visualization ## 

t_data %>%
  ggplot() +
  geom_polygon(aes(x=slat, y= slon, color = "red")) +
  coord_fixed(1.3)

