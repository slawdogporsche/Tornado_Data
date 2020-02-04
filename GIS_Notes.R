#############
#############
### SETUP ###
#############
#############

## https://www.nickeubank.com/gis-in-r/

library(sp)
library(raster)

setwd("~/Random_Stuff/GIS_stuff")

###########################
###########################
### Vector Spatial Data ###
###########################
###########################

## Creating points ##
toy.coordinates <- rbind(c(1.5, 2), c(2.5,2), c(0.5, 0.5), c(1,0.25), c(1.5, 0), c(2,0), c(2.5,0), c(3,0.25), c(3.5,0.5))

## Converting to spatial object ##
my.first.points <- SpatialPoints(toy.coordinates)

plot(my.first.points)

summary(my.first.points)

coordinates(my.first.points)

## Adding a CRS (Coordinate Reference System ##)

## Checking to see if projection is defined ##
is.projected(my.first.points)

## CRS can be assigned with reference code or directly calling parameters ##
CRS("+init=EPSG:4326")
CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

crs.geo <- CRS("+init=EPSG:32633") ## UTM 33N
proj4string(my.first.points) <- crs.geo ## define projection system
is.projected(my.first.points)
summary(my.first.points)

## When CRS is called with only an EPSG code, R will try to complete CRS 
## with parameters looked up in EPSG table 

## Geometry only objects can be subsetted like vectors or lists 
my.first.points[1:2]

## Adding attributes ## 
## Moving from spatialpoints to a spatialpointsdataframe
## Occurs when adding a data.frame of attributes to points
## NOTE: Points will merge with the data.frame based on order of observations

df <- data.frame(attr1 = c("a", "b", "z", "d", "e", "q", "w", "r", "z"), attr2 = c(101:109))

my.first.spdf <- SpatialPointsDataFrame(my.first.points,df)
summary(my.first.spdf)

my.first.spdf[1:2,]

my.first.spdf[1:2, "attr1"]

## Plotting dataframe when attribute2 is greater than 105
plot(my.first.spdf[which(my.first.spdf$attr2 > 105), ])

##############
## EXERCISE ##
##############

## Loading Data ##
sf_inspec <- read.csv("RGIS1_Data/sf_restaurant_inspections.csv")

## Converting to spatial Object ## 
## Note reverse order)
coordinates(sf_inspec) <- c("longitude", "latitude")

## Plotting bad restaurants ##
plot(sf_inspec[which(sf_inspec$Score < 80), ])

######################
## SPATIAL POLYGONS ##
######################

## Created by creating Polygon objects, combining those into Polygons
## Objects, and combining those into SpatialPolygons
## Ex Each island in Hawaii would be a Polygon, the island of Hawaii
## Would be a Polygons
## For a map of the US, you would have a SpatialPolygons composed of
## Polygons for each state 
## If you want to create a hole, you do so by creating a polygon for outline
## Creating a second polygon for the hole, and passing the argument hole=TRUE
## Combine the two into a polygons object 

house1.building <- Polygon(rbind(c(1,1), c(2,1), c(2,0), c(1,0)))
house1.roof <- Polygon(rbind(c(1,1), c(1.5,2), c(2,1)))

house2.building <- Polygon(rbind(c(3,1), c(4,1), c(4,0), c(3,0)))
house2.roof <- Polygon(rbind(c(3,1), c(3.5,2), c(4,1)))

house2.door <- Polygon(rbind(c(3.25, 0.75), c(3.75, 0.75), c(3.75, 0), c(3.25, 0)), hole = TRUE)

## Create lists of polygon objects and unique ID A
## Polygons is a single observation 

h1 <- Polygons(list(house1.building, house1.roof), "house1")
h2 <- Polygons(list(house2.building, house2.roof, house2.door), "house2")

## Create spatial polygons object from lists A SpatialPolygons
## It's like a shapefile or layer

houses <- SpatialPolygons(list(h1,h2))
plot(houses)

## Adding attributes to SpatialPolygon ##
## We can associate a data.frame with SpatialPolygons ##
## When you first associate a data.frame with a SpatialPolygons
## Object, R will line up rows and polygons by matching Polygons
## object names with data.frame row.names
## After initial association, this relationship is no longer based
## on row.names. For the rest of the SpatialPolygonsDataFrame life, 
## association between Polygons and rows of data.frame is based on 

## Making attributes and plot. Note empty door ##
attr <- data.frame(attr1 = 1:2, attr2 = 6:5, row.names = c("house2", "house1"))

houses.DF <- SpatialPolygonsDataFrame(houses, attr)
as.data.frame(houses.DF)
spplot(houses.DF)

## Adding a CRS ## 
crs.geo <- CRS("+init=EPSG:4326")
proj4string(houses.DF) <- crs.geo

################
## EXERCISE 2 ##
################

## Creating Coordinates ##
south.africa  <- rbind(c(16, -29), c(33, -21), c(33, -29), c(26, -34), c(17, -35))
lesotho <- rbind(c(29, -28), c(27, -30), c(28, -31))
south.africa.hole <- rbind(c(29, -28), c(27, -30), c(28, -31))

## Making polygons ##
sa.outline.poly <- Polygon(south.africa)
sa.hole.poly <- Polygon(south.africa.hole, hole = TRUE)
lesotho.poly <- Polygon(lesotho)

## Make Polygons objects ##
sa.polys <- Polygons(list(sa.outline.poly, sa.hole.poly), "SA")
lesotho.polys <- Polygons(list(lesotho.poly), "Lesotho")

## Make spatial Polygons ##
map <- SpatialPolygons(list(sa.polys, lesotho.polys))

plot(map)

## Adding Data ##
df <- data.frame(c(7000,1000), row.names = c("SA", "Lesotho"))
mapDF <- SpatialPolygonsDataFrame(map, df)

## Add WGS 84 CRS ##
proj4string(mapDF) <- CRS("+init=EPSG:4326")
spplot(mapDF)


###################
###################
### Raster Data ###
###################
###################


## Creating a basic raster ## 
basic_raster <- raster(ncol = 5, nrow = 10, xmn = 0, xmx = 5, ymn = 0, ymx = 10)

basic_raster

## It has a grid, but no data ##g
hasValues(basic_raster)

## Add data to raster using values function ##
## Even though a grid is a 2d object, raster looks for
## One dimensional data, then assigns values by starting
## At top left and moving from left to row and down
## Each column must be the length of the total number
## of cells
values(basic_raster) <- 1:50
plot(basic_raster)

## Defining a projection ##
## Use same proj4 strings as vector data
## Without intermediate step of creating CRS object
## (Coordinate reference system) ##
projection(basic_raster) <- "+init=EPSG:4326"

raster_from_file <- raster("RGIS1_Data/SanFranciscoNorth.dem")

## San Francisco elevation data ## 
plot(raster_from_file)

## You can modify and interrogate raster objects 
## Beware, changing the number of columns and rows
## will change the resolution and vice versa
## If you change the dimensions, any values associated
## with the data will be erased

## Check resolution ##
res(basic_raster)

## Change resolution ##
#res(basic_raster) <- c(x value, y value)

## Check number of columns ##
# ncol(basic_raster)

## Change number of columns 
#ncol(basic_raster) <- value