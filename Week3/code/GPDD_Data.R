##Visualising the dataset on the global map

#Author: Chalita Chomkatekaew (chalita.chomkatekaew20@ic.ac.uk)
#version: 0.0.1

#Clean everything
rm(list = ls())

#packages
require(maps)
require(ggplot2)

#load dataset

mydata <- load("../data/GPDDFiltered.RData")

gpdd$common.name <- as.factor(gpdd$common.name)

#load world data

world <- map_data("world")

#Plot the data on to the world map

GPDD <- ggplot() +
  geom_polygon(data = world, aes(x = long, y = lat, group = group), 
               fill= "grey", alpha = 0.3) +
  geom_point(data = gpdd, aes(x = long, y =lat, colour = common.name), size = 2, alpha = 0.8) +
  theme_void() + coord_map(xlim=c(-180,180)) +
  theme(legend.position = "none") 

#Although this is a global database, the majority of the data was collected from the North
#America and European countries, particularly from the UK and West American states. 
#While the database is lacking information from South America, Africa, Asia and Australasia continents.

