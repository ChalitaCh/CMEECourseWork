#GIS practical 1 part 1
#Date 01/11/21

rm(list = ls())
#install the packages needed for the practical
install.packages('raster')
install.packages('sf')
install.packages('sp')
install.packages('rgeos')
install.packages('rgdal')
install.packages('lwgeom')

library(rgdal)
library(raster)
library(sf)
library(sp)
library(rgeos)
library(units)

#create a population desity map for the British Isles

pop_dens <- data.frame(n_km2 = c(260, 67,151,4500,133),
                       country = c('England', 'Scotland', 'Walses','London','Northern Ireland'))

# Create coordinates  for each country 
# - this creates a matrix of pairs of coordinates forming the edge of the polygon. 
# - note that they have to _close_: the first and last coordinate must be the same.
scotland <- rbind(c(-5, 58.6), c(-3, 58.6), c(-4, 57.6), 
                  c(-1.5, 57.6), c(-2, 55.8), c(-3, 55), 
                  c(-5, 55), c(-6, 56), c(-5, 58.6))
england <- rbind(c(-2,55.8),c(0.5, 52.8), c(1.6, 52.8), 
                 c(0.7, 50.7), c(-5.7,50), c(-2.7, 51.5), 
                 c(-3, 53.4),c(-3, 55), c(-2,55.8))
wales <- rbind(c(-2.5, 51.3), c(-5.3,51.8), c(-4.5, 53.4),
               c(-2.8, 53.4),  c(-2.5, 51.3))
ireland <- rbind(c(-10,51.5), c(-10, 54.2), c(-7.5, 55.3),
                 c(-5.9, 55.3), c(-5.9, 52.2), c(-10,51.5))

#Convert these coordinates into feature geometries
scotland <- st_polygon(list(scotland))
england <- st_polygon(list(england))
wales <- st_polygon(list(wales))
ireland <- st_polygon(list(ireland))

#Combine geometries into a simple feature column
uk_eire <- st_sfc(wales, england, scotland, ireland, crs = 4326)
plot(uk_eire, asp = 1)

#4326 is just a unique numeric code in the EPSG database of spatial coordinate systems
#4326 is the WGS84 geographic coordinate sustem.

#Making vector points from a dataframe
uk_eire_capitals <- data.frame(long = c(-0.1,-3.2,-3.2,-6.0,-6.25),
                               lat = c(51.5,51.5,55.8,54.6,53.3),
                               name = c('London','Cardiff','Edinburgh','Belfast','Dublin'))

#Indicate which fields in the data frame contain the coordinates
uk_eire_capitals <- st_as_sf(uk_eire_capitals, coords = c('long','lat'), crs = 4326)
print(uk_eire_capitals)

#Buffer operation to create a polygon for London
#define as anywhere within a quater degree of St.Pauls Cathedral - just for the illustration
#0.25 degree buffering point for london is stupid, because there are not a constand unit of distance
#and as lines of longitude converge towards to pole, the physical length of a degree decreases.
#Therefore, the degrees are not constant
#the buffering degrees can be distorted in the projected data

st_pauls <- st_point(x=c(-0.098056, 51.513611))
london <- st_buffer(st_pauls, 0.25)

#Remove london from the England polygon, so that we can set different population densities for the two regions
#Using the difference operation

england_no_london <- st_difference(england, london)

lengths(england_no_london)

#giving the two components = 18 and 242
#one ring for the 18 points along the external border
#second right of 242 points for the internal hold

wales <- st_difference(wales, england)

# A rough polygon that includes Northern Ireland and surrounding sea.
# - not the alternative way of providing the coordinates
ni_area <- st_polygon(list(cbind(x=c(-8.1, -6, -5, -6, -8.1), y=c(54.4, 56, 55, 54, 54.4))))

northern_ireland <- st_intersection(ireland, ni_area)
eire <- st_difference(ireland, ni_area)

#Combine the final geometries
uk_eire <- st_sfc(wales, england_no_london, scotland, 
                  london, northern_ireland, eire, crs = 4326)

#Compare six Polygon features wtih one mulipolygon feature
print(uk_eire)

#make the UK into a signle feature
uk_country <- st_union(uk_eire[-6])
print(uk_country)

#Plot them
par(mfrow = c(1, 2), mar = c(3, 3, 1,1))
plot(uk_eire, asp = 1, col = rainbow(6))
plot(st_geometry(uk_eire_capitals), add = TRUE)
plot(uk_country, asp = 1, col = 'lightblue')

#Features and attributes to the GIS data
uk_eire <- st_sf(name = c('Wales', 'England', 'Scotland', 'London',
                          'Northern Ireland', 'Eire'),
                 geometry = uk_eire)

plot(uk_eire, asp= 1)

#sf object is an extended data frame, we can add attributes by adding the fields directly

uk_eire$capital <- c('Cardiff', 'London','Edinburgh',
                     NA, 'Belfast','Dublin')
print(uk_eire)

#merge data frame with the population density one
uk_eire <- merge(uk_eire, pop_dens, by.x = 'name', by.y='country', all.x = TRUE)

#spatial attributes

uk_eire_centroids <- st_centroid(uk_eire)
#got warning?

st_coordinates(uk_eire_centroids)

uk_eire$area <- st_area(uk_eire)
#To calculate a 'length' of a polygon, you have to
#convert it to a LINESTRING or a MULTILINESTRING
#Using MULTILINESTRING will automatically
#include all perimeter of a polygon (including holes).

uk_eire$length <- st_length(st_cast(uk_eire, 'MULTILINESTRING'))

#Look at the result
print(uk_eire)

#You can change units in a neat way
uk_eire$area <- set_units(uk_eire$area, 'km^2')
uk_eire$length <- set_units(uk_eire$length, 'km')
print(uk_eire)

#sf can give us the closest distance btw geometries

st_distance(uk_eire_centroids)

#plotting sf objects
#logz gives the log scale
#key.pos determine the key position
#?plot.sf for more details

plot(uk_eire['n_km2'], asp = 1, logz = TRUE,  key.pos = 4)

##Reprojection
#is moving data from one set of coordinates to another.
#Reprojection data is often used to convert from a geographical coordinate system - with units of degrees
#to a projected coordinate system with linear units.

#Example
#British National Grid (EPSG:27700)

uk_eire_BNG <- st_transform(uk_eire, 27700)

#UTM50N (EPSG:32650)

uk_eire_UTM50N <- st_transform(uk_eire, 32650)

#The bounding boxes of the data shows the change in units
st_bbox(uk_eire)

st_bbox(uk_eire_BNG)

#Plot the results
par(mfrow=c(1, 3), mar = c(3, 3,1,1))
plot(st_geometry(uk_eire), asp = 1, axes = TRUE, main = 'WGS 84')
plot(st_geometry(uk_eire_BNG), axes = TRUE, main='OSGB 1936/BNG')
plot(st_geometry(uk_eire_UTM50N), axes = TRUE, main = 'UTM 50N')

#0.25 degree buffering point for london is stupid, because there are not a constand unit of distance
#and as lines of longitude converge towards to pole, the physical length of a degree decreases.
#Therefore, the degrees are not constant
#the buffering degrees can be distorted in the projected data

#Set up some points separated by 1 degree lat and long from St. Pauls
st_pauls <- st_sfc(st_pauls, crs = 4326)
one_deg_west_pt <- st_sfc(st_pauls - c(1,0), crs = 4326) #near Goring
one_deg_north_pt <- st_sfc(st_pauls + c(0, 1), crs = 4326) #near Peterborough

#Calculate the distance between St Pauls and each point
st_distance(st_pauls, one_deg_west_pt)
st_distance(st_pauls, one_deg_north_pt)

st_distance(st_transform(st_pauls, 27700),
            st_transform(one_deg_west_pt, 27700))

##RASTERS
#other major type of spatial data
#consist of a regular grid in space, defined by a coordinate system,
#an origin point, a resolution, and a number of rows and columns.
#a matrix of data

#Creating a raster
#Create an empty raster objet covering UK and Eire

uk_raster_WGS84 <- raster(xmn = -11, xmx=2, ymn=49.5, ymx=59,
                          res=0.5, crs="+init=EPSG:4326")
hasValues(uk_raster_WGS84)

#Add data to the raster:just the number 1 to number of cells
values(uk_raster_WGS84) <- seq(length(uk_raster_WGS84))
print(uk_raster_WGS84)

plot(uk_raster_WGS84)
#add=TRUE allowing the vector data to be added to the existing map
plot(st_geometry(uk_eire), add=TRUE, border='black', lwd=2, col='#FFFFFF44')

#Changing raster resolution
#Define a simple 4x4 square raster
m <- matrix(c(1,1,3,3,
              1,2,4,3,
              5,5,7,8,
              6,6,7,7), ncol=4,byrow = TRUE)
square <-raster(m)

#The following methods dont change the origin or alignments of cell borders,
#They only lump or split values within the sample grid framework
#Aggregating raster

#Average values
#fact = how many cells to group
#func = function to calculate when grouping cells tgt
#continuous value - mean/maximun
#but catergorical values can be tricky
square_agg_mean <- aggregate(square, fact = 2, fun = mean)
as.matrix(square_agg_mean)

#Maximum values
square_agg_max <- aggregate(square, fact=2, fun=max)
as.matrix(square_agg_max)

#Modal values for categories
square_agg_modal <- aggregate(square, fact = 2, fun=modal)
as.matrix(square_agg_modal)

#Disaggregating rasters
#require factors
#copy the parent cell values into the new cells > work for both continuous and categorical values
#another option is to interpolate between the values to provide a smoother gradient between cell
#but only work for continuous values

#copy parents
square_disagg <- disaggregate(square, fact = 2)
#Interpolate
square_disagg_interp <- disaggregate(square, fact =2, method='bilinear')

#To match datasets and they have different origins and alignments then you need to use
#more complex resample function

##Reprojecting a raster
#Comparing 0.5 degrees WGS84 raster for the uk and eire with 100km resolution raster
#on the British National Grid
#make two simple 'sfc' objects containing points in the
#lower left and top right of the two grids
uk_pts_WGS84 <- st_sfc(st_point(c(-11,49.5)),
                       st_point(c(2, 59)),
                       crs=4326)
uk_pts_BNG <- st_sfc(st_point(c(-2e5, 0)),
                     st_point(c(7e5,1e6)),
                     crs=27700)

#Use st_make_grid to quickly create a polygon grid with the right cellsize
uk_grid_WGS84 <- st_make_grid(uk_pts_WGS84,cellsize = 0.5)
uk_grid_BNG <- st_make_grid(uk_pts_BNG, cellsize = 1e5)

#Reproject BNG grid into WGS84
uk_grid_BNG_as_WGS84 <- st_transform(uk_grid_BNG,4326)

#plot the features
plot(uk_grid_WGS84, asp = 1, border ='grey', xlim=c(-13, 4))
plot(st_geometry(uk_eire), add=TRUE, border='darkgreen',lwd=2)
plot(uk_grid_BNG_as_WGS84, border='red',add=TRUE)

#projectRaster function
#2 methods
#method ='bilinear' >> interpolating a representative value from the source data
#method = 'ngb >> picking the cell values from the nearest neighbour to the new cell centre

#Create the target raster
uk_raster_BNG <- raster(xmn=-200000, xmx=700000, ymn=0, ymx=1000000,
                        res=100000, crs='+init=EPSG:27700')

uk_raster_BNG_interp <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method = 'bilinear')
uk_raster_BNG_ngb <- projectRaster(uk_raster_WGS84, uk_raster_BNG, method = 'ngb')

#compare the values in the top row
round(values(uk_raster_BNG_interp)[1:9], 2)
values(uk_raster_BNG_ngb)[1:9]

par(mfrow=c(1,2), mar=c(1, 1,2,1))
plot(uk_raster_BNG_interp, main='Interpolated', axes= FALSE, legend=FALSE)
plot(uk_raster_BNG_ngb, main='Nearest Neighbour', axes = FALSE, legend = FALSE)

#Converting between vector and raster data types
#Why converting
#Usually an analysis is using one or the other. 
#For example, spatial models and SDMs, which we are looking at later this week, 
#normally work on a raster grid. If you have some data you want to include that is only available as a vector, 
#then you have to rasterise it to use it. A species range is a classic example - what raster cells does the species occur in 
#- but you could also have a river linestring that you want to include.

#Alternatively, you may want to use vector operations to do something with a raster layer: 
#for example you might want to find out the proportions of different land cover in a species range. 
#That might be easiest to do by turning the raster into a polygon layer first. 
#This approach rarely works well with continuous raster values - because you end up with a polygon layer that consists of individual grid cells as polygons 
#- but can be very useful with categorical data.

#Vector to raster
#Create the target raster

uk_20km <- raster(xmn=-200000, xmx=650000, ymn=0, ymx=1000000, 
                  res=20000, crs='+init=EPSG:27700')

#change to factor for compatibility
uk_eire_BNG$name <- as.factor(uk_eire_BNG$name)
#set the attributes relation of sf object
st_agr(uk_eire_BNG) <- 'constant'

#Rasterizing polygons
uk_eire_poly_20km  <- rasterize(as(uk_eire_BNG, 'Spatial'), uk_20km, field='name')

#Rasterizing lines
uk_eire_BNG_line <- st_cast(uk_eire_BNG, 'LINESTRING')
uk_eire_line_20km <- rasterize(as(uk_eire_BNG_line,'Spatial'), uk_20km, field='name')

#Rasterizing points
# - This isnt quite as neat. You need to take two steps in the cast and need to convert
# the name factor to numeric

uk_eire_BNG_point <- st_cast(st_cast(uk_eire_BNG, 'MULTIPOINT'), 'POINT')
uk_eire_BNG_point$name <- as.numeric(uk_eire_BNG_point$name)
uk_eire_point_20km <- rasterize(as(uk_eire_BNG_point, 'Spatial'), uk_20km, field = 'name')

#Plotting those different outcomes
#- Use the hcl.colors function to create a nice plotting palette
colour_palette <- hcl.colors(6, palette = 'viridis', alpha = 0.5)

#Plot each raster
par(mfrow=c(1,3), mar=c(1,1,1,1))
plot(uk_eire_poly_20km, col = colour_palette, legend = FALSE, axes = FALSE)
plot(st_geometry(uk_eire_BNG), add= TRUE, border ='grey')

plot(uk_eire_line_20km, col = colour_palette, legend = FALSE, axes = FALSE)
plot(st_geometry(uk_eire_BNG), add = TRUE, border = 'grey')

plot(uk_eire_point_20km, col = colour_palette, legend =FALSE, axes = FALSE)
plot(st_geometry(uk_eire_BNG), add= TRUE, border = 'grey')

#Raster to vector

#rasterToPolygons returns a polygon for each cell and returns a spatial object
poly_from_rast <- rasterToPolygons(uk_eire_poly_20km)
poly_from_rast <- as(poly_from_rast, 'sf')

#but can be set to dissolved the boundaries between cells with identical values
poly_from_rast_dissolve <- rasterToPolygons(uk_eire_poly_20km, dissolve = TRUE)
poly_from_rast_dissolve <- as(poly_from_rast_dissolve, 'sf')

#rasterToPoints returns a matrix of coordinates and values
points_from_rast <- rasterToPoints(uk_eire_poly_20km)
points_from_rast <- st_as_sf(data.frame(points_from_rast), coords = c('x','y'))

#Plot the outputs - using key.pos =NULL to suppress the key and 
#reset=FALSE to avoid plot.sf altering the par() option
par(mfrow=c(1,3), mar=c(1,1,1,1))
plot(poly_from_rast['layer'], key.pos = NULL, reset = FALSE)
plot(poly_from_rast_dissolve, key.pos= NULL, reset = FALSE)
plot(points_from_rast, key.pos = NULL, reset = FALSE)

#saving vector data
#sf package will save the file based on the suffix but if not standard suffix used
#we can specifiy a driver - i.e. specific file type manually

st_write(uk_eire, 'data/uk_eire_WGS84.shp')
st_write(uk_eire_BNG,'data/uk_eire_BNG.shp')

#.geojson - technically human readable but you have to be familar with JSON data structure
st_write(uk_eire, 'data/uk_eire_WGS84.geojson')

#geopackge stores vector data in a single SQLite 3 database
#mulitple tables inside holding various information about the data
#very portable and in a single file
st_write(uk_eire, 'data/uk_eire_WGS84.gpkg')

st_write(uk_eire, 'data/uk_eire_WGS84.json', driver = 'GeoJSON')

#saving raster data
#GeoTIFF file is one of the most common GIS raster data formats
#a TIFF image file but contains embedded data describing the origin, resolution and coordinate ref

#Save a GeoTiff
writeRaster(uk_raster_BNG_interp, 'data/uk_raster_BNG_interp.tif')

#Save an ASCII format file:human readable text.
#Note that this format does not contain the projection details!

writeRaster(uk_raster_BNG_ngb, 'data/uk_raster_BNG_ngb.asc', format='ascii')
