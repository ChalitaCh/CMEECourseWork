#GIS practical 1 part 2
#Date 02/11/21

#load the libraries
library(rgdal)
library(raster)
library(sf)
library(sp)
library(rgeos)
library(units)

#load a vector shapefile
ne_100 <- st_read('ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')

#also load some WHO data on 2016 life expectancy
life_exp <- read.csv(file = "WHOSIS_000001.csv")

#merging the two dataset together
ne_100_life_exp <- merge(ne_100, life_exp, by.x="ISO_A3_EH", by.y="COUNTRY", all.x=TRUE)

#plotting the GDP
plot(ne_100_life_exp['GDP_MD_EST'], logz = TRUE, asp =1 , main = 'Global GDP', key.pos = 4)

colour_palette <- hcl.colors(5, palette = "ag_GrnYl", alpha = 0.5)
#plotting the life expextancy
plot(ne_100_life_exp['Numeric'], asp =1, key.pos = 4)

#loading XY data
#Read in Southern Ocean example data
so_data <- read.csv('Southern_Ocean.csv', header = TRUE)
head(so_data)

#Convert the data frame to an sf object
so_data <- st_as_sf(so_data, coords = c('long', 'lat'), crs = 4326)
head(so_data)

#loading Raster data
etopo_25 <- raster('etopo_25.tif')
print(etopo_25)
plot(etopo_25)

pal <- colorRampPalette(c("blue","white","red"))

plot(etopo_25, axis.args=list(at=c(-10000, 0, 6000), lab=c(-10, 0, 6)),col = pal(30))

#Raster Stacks

#Download bioclim data:global maximum temperature at 10 arc minute resolution
tmax <- getData('worldclim', path = "", var= 'tmax', res=10)
#The data has 12 layers, one for each month
print(tmax)

#scale the data
tmax <- tmax/10

#Extract January and July data and the annual maximum by location
tmax_jan <- tmax[[1]]
tmax_jul <- tmax[[7]]
tmax_max <- max(tmax)

#Plot those maps
par(mfrow = c(3,1), mar=c(2,2,1,1))
bks <- seq(-50,50, length=101)
pal <- colorRampPalette(c('lightblue','grey','firebrick'))
cols <- pal(100)
ax.args <- list(at = seq(-50, 50, by =100))
plot(tmax_jan, col= cols, breaks = bks, axis.args=ax.args, main= 'January maximum temperature')
plot(tmax_jul, col = cols, breaks = bks, axis.args=ax.args, main= 'July maximum temperature')
plot(tmax_max, col = cols, breaks = bks, axis.args=ax.args,main = 'Annual maximum temperature')


#Cropping data

so_extent <- extent(-60, -20, -65,-45)
#The crop function for raster data...
so_topo <- crop(etopo_25, so_extent)

#... and the st_crop function to reduce some higher resolution coastline data
ne_10 <- st_read('ne_10m_admin_0_countries/ne_10m_admin_0_countries.shp')
st_agr(ne_10) <- 'constant'
so_ne_10 <- st_crop(ne_10, so_extent)

dev.off()
par(mfrow = c(1,2), mar=c(1,1,1,1))
plot(so_topo, asp = 1, col = cols, legend = FALSE)
contour(so_topo, levels =c(-2000,-4000,-6000), add =TRUE, col='grey90')
plot(st_geometry(so_ne_10), add = TRUE, col='grey90', border = 'grey40')
plot(so_data['chlorophyll'], add =TRUE, logz = TRUE, pch = 20, cex =2, pal = hcl.colors, border = 'white', reset = FALSE)
.image_scale(log10(so_data$chlorophyll), col=hcl.colors(18), key.length=0.8, key.pos=4, logz=TRUE)


#spatial joining

set.seed(1)
sf_use_s2(FALSE)
#extract Africa from the ne_110 data and keep the columns we want to use
africa <- subset(ne_100, CONTINENT =='Africa', select=c('ADMIN', 'POP_EST'))
#transform to Robinson projection
africa <- st_transform(africa, projection= "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")
mosquito_points <-st_sample(africa, 1000)

#Create the plot
plot(st_geometry(africa), col ='khaki')
plot(mosquito_points, col='firebrick', add=TRUE)

#Join these datasets together
#turn mosquito_points from a geometry columns (sfc) into sf data frame

mosquito_points <- st_sf(mosquito_points)
mosquito_points <- st_join(mosquito_points, africa['ADMIN'])

plot(st_geometry(africa), col = 'Khaki')
plot(mosquito_points['ADMIN'], add= TRUE)

#now we can aggregate the points within countries and can count the number of points in each one

mosquito_points_agg <- aggregate(mosquito_points, by=list(country=mosquito_points$ADMIN), FUN=length)
names(mosquito_points_agg)[2] <- 'n_outbreaks'
head(mosquito_points_agg)

africa <- st_join(africa, mosquito_points_agg)
africa$area <- as.numeric(st_area(africa))
head(africa)

par(mfrow= c(1,2), mar=c(3,3,1,1), mgp =c(2,1,0))
plot(n_outbreaks~ POP_EST, data = africa, log='xy',
     ylab='Number of outbreaks', xlab = 'Population size')
plot(n_outbreaks ~ area, data = africa, log='xy',
     ylab = 'Number of outbreaks', xlab='Area (m2)')

#Alien invasion exercise
alien_xy <- read.csv('aliens.csv')
alien_xy <- st_as_sf(alien_xy, coords=c('long','lat'), crs=4326)

alien_xy <- st_join(alien_xy, ne_100)
alien_by_country <- aggregate(n_aliens ~ ADMIN, data=alien_xy, FUN = sum)

ne_100<- merge(ne_100, alien_by_country, all.x =TRUE)
ne_100$aliens_per_capita <- with(ne_100, n_aliens/POP_EST)

bks <- seq(-8, 2, length =101)
pal <- colorRampPalette(c('darkblue', 'lightblue','salmon','darkred'))

plot(ne_100['aliens_per_capita'], logz = TRUE, breaks=bks, pal=pal,key.pos=4)

#Extracting data from Rasters

uk_eire_etopo <-raster('etopo_uk.tif')

