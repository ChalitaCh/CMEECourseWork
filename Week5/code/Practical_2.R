#GIS practical 2 
#Date 04/11/21

rm(list=ls())
setwd('/Users/chalitachomkatekaew/Documents/CMEE/Week5_GIS/Practical_two_data/')

#Load the essential packages

library(rgdal)
library(raster)
library(sf)
library(sp)
library(dismo)

#load the multipolygon

tapir_IUCN <- st_read('iucn_mountain_tapir/data_0.shp')
print(tapir_IUCN)

#load the data frame

tapir_GBIF <- read.delim('gbif_mountain_tapir.csv',
                         stringsAsFactors = FALSE)

#Drop rows with missing coordinates

tapir_GBIF <- subset(tapir_GBIF, !is.na(decimalLatitude) | !is.na(decimalLongitude))

#Convert to an sf object

tapir_GBIF <- st_as_sf(tapir_GBIF, coords = c('decimalLongitude','decimalLatitude'))

st_crs(tapir_GBIF) <- 4326
print(tapir_GBIF)

#Load some (coarse) country background data
ne_110 <- st_read('ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp')

#Create a modelling extent for plotting and cropping the global data

model_extent <- extent(c(-85, -70, -5, 12))

#Plot the species data over a basemap
plot(st_geometry(ne_110), xlim=model_extent[1:2], ylim=model_extent[3:4],
     bg='lightblue', col='ivory')
plot(st_geometry(tapir_IUCN), add=TRUE, col='grey', border = NA)
plot(st_geometry(tapir_GBIF), add = TRUE, col = 'red', pch=4, cex=0.6)
box()

##Predictor variables
#Load the data

bioclim_hist <- getData('worldclim', var='bio', res=10, path='')
bioclim_2050 <- getData('CMIP5', var='bio', res=10, rcp=60, model='HD', year=50, path='')

#Relabel the future variables to match the historical ones
names(bioclim_2050) <- names(bioclim_hist)

#Look at the data structure
print(bioclim_hist)

#Comparing BIO1 (Mean Annual Temperature) between the two datasets
par(mfrow = c(3,1), mar=c(1,1,1,1))

#Create a shared colour scheme
breaks <- seq(-300, 350, by =20)
cols <- hcl.colors(length(breaks)- 1)

#Plot the historical and projected data
plot(bioclim_hist[[1]], breaks = breaks, col=cols)
plot(bioclim_2050[[1]], breaks= breaks, col= cols)

#Plot the temperature difference
plot(bioclim_2050[[1]] - bioclim_hist[[1]], col = hcl.colors(20, palette = 'Inferno'))

#Reduce the global maps down to the species'range
#In this case, we are cropping the data dowm to a semsible modelling region
#but what counts as sensible here is very hard to define

bioclim_hist_local <- crop(bioclim_hist, model_extent)
bioclim_2050_local <- crop(bioclim_hist, model_extent)

#Pseudo-absence data
#many of the methods require absence data, either for fitting a model or for evaluating the model performamce.
#rarely we will have real absence data, but usually we only have presence data
#so modelling commonly uses
#1. pseudo-absence - attempt to pick location that are somehow separated from presence  observations.
#2. background data - sampling completely at randoms

#randomPoint function from dismo package
#will select background data - it works directly with the environmental layers to pick point representating cells.
#and avoids getting duplicate points in the same cells.
#need to provide a mask layer that shows which cells are valid choices
#can also exclide cells that contain observed locations by setting p to use the coordinates of your observed location

#Create a simple land mask

land <- bioclim_hist_local[[1]] >= 0

#How many points to create? We'll use the same as number of observations
n_pseudo <- nrow(tapir_GBIF)

#Sample the points
pseudo_dismo <- randomPoints(mask = land, n = n_pseudo, p = st_coordinates(tapir_GBIF))

#Convert this data into an sf object, for consistency with
#next example

pseudo_dismo <- st_as_sf(data.frame(pseudo_dismo), coords = c('x', 'y'), crs=4326)

#Create buffers around the observed points to pick points that
#are within about 100 km of observed points, but not closer than 20 km
#this is cheating, but in practice it would be better to reproject the data and
#work with real distance units

nearby <- st_buffer(tapir_GBIF, dist = 1)
too_close <- st_buffer(tapir_GBIF, dist= 0.2)

#merge those buffers

nearby <- st_union(nearby)
too_close <- st_union(too_close)

#Find the area that is nearby but _not_ too close

nearby <- st_difference(nearby, too_close)

#Get some points within that feature in an sf dataframe

pseudo_nearby <- st_as_sf(st_sample(nearby, n_pseudo))

par(mfrow=c(1,2), mar=c(1,1,1,1))
#Random points on land
plot(land, col='grey', legend = FALSE)
plot(st_geometry(tapir_GBIF), add = TRUE, col='red')
plot(pseudo_dismo, add= TRUE)

#Random points within ~100 km but not closer than ~ 20 km 
plot(land, col='grey', legend = FALSE)
plot(st_geometry(tapir_GBIF), add =TRUE, col='red')
plot(pseudo_nearby, add= TRUE)

#Testing and training dataset
#dividing 80% for fitting the model and 20% for testing

#Usek Kfold to add labels to the data, splitting it into 5 parts
tapir_GBIF$kfold <- kfold(tapir_GBIF, k=5)

#Do the same for the pseudo-random points
pseudo_dismo$kfold <- kfold(pseudo_dismo, k=5)
pseudo_nearby$kfold <- kfold(pseudo_nearby, k =5)

#Species Distribution Modelling
#Fitting the model

#Get the coordinates of 80% of the data for training
train_locs <- st_coordinates(subset(tapir_GBIF, kfold !=1))

#Fit the model
bioclim_model <- bioclim(bioclim_hist_local, train_locs)

par(mfrow=c(1,2))
#p is used to show the climatic envelop that contains a certain proportion of the data
#in this case 90%
#a and b set which layers in the environmental data are compared

plot(bioclim_model, a=1,b=2,p=0.9)
plot(bioclim_model, a=1, b=5, p=0.9)

#Model predictions
bioclim_pred <- predict(bioclim_hist_local, bioclim_model)
#create a copy removing zero scores to focus on within envelop locations
bioclim_non_zero <- bioclim_pred
bioclim_non_zero[bioclim_non_zero == 0] <- NA

plot(land, col='grey', legend = FALSE)
plot(bioclim_non_zero, col=hcl.colors(20, palette='Blue-Red'), add =TRUE)

#Model evaluation

test_locs <- st_coordinates(subset(tapir_GBIF, kfold ==1))
test_pseudo <- st_coordinates(subset(pseudo_nearby, kfold ==1))

bioclim_eval <- evaluate(p=test_locs, a=test_pseudo, model=bioclim_model,
                         x= bioclim_hist_local)

print(bioclim_eval)

par(mfrow=c(1,2), mar=c(1,1,1,1))
#Plot the ROC curve
plot(bioclim_eval, 'ROC', type = 'l')

#Find the maximum kappa and show how kappa changes with the model
max_kappa <- threshold(bioclim_eval, stat='kappa')
plot(bioclim_eval, 'kappa', type = 'l')
abline(v=max_kappa, lty = 2, col='blue')

#Species distribution
#The above commands give us all the info we need to make a prediction about the species
#distribution

#Apply the threshold to the model predictions
tapir_range <- bioclim_pred >= max_kappa
plot(tapir_range, legend = FALSE, col=c('grey','red'))
plot(st_geometry(tapir_GBIF), add= TRUE, pch=4, col='#00000022')

#Generalised Linear Model(GLM)

#Restructuring the data to suit the GLM modelling
#combine tapir_GBIF and pseudo_nearby into a single data frame

#Create a single sf object holding presence and pseudo-absense data
#- reduce the GBIF data and pseudo-absence to just kfold and a presence-absence value

present <- subset(tapir_GBIF, select='kfold')
present$pa <- 1
absent <- pseudo_nearby
absent$pa <- 0

#- rename the geometry column of absent to match so we can stack them together
names(absent) <- c('geometry', 'kfold', 'pa')
st_geometry(absent) <- 'geometry'

#- stack the two dataframes
pa_data <- rbind(present, absent)
head(pa_data)

#extract the environmental values for each of those points and add it into the dataframe

envt_data <- extract(bioclim_hist_local, pa_data)
pa_data <- cbind(pa_data, envt_data)
head(pa_data)

#Model fitting for GLM

glm_model <- glm(pa ~ bio2 + bio4 + bio3 + bio1 + bio12, data = pa_data,
                 family = binomial(link = "logit"),
                 subset=kfold !=1)

#Look at the variable significance - which are important
summary(glm_model)

#Response plots
response(glm_model, fun = function(x, y, ...) predict(x, y, type = 'response', ...))

#Model predictions and evaluation
#Create a prediction layer
glm_pred <- predict(bioclim_hist_local, glm_model, type = 'response')

#Evaluate the model using the test data
#Extract the test presence and absence

test_present <- st_coordinates(subset(pa_data, pa == 1 & kfold == 1))
test_absent <- st_coordinates(subset(pa_data, pa == 0 & kfold == 1))
glm_eval <- evaluate(p=test_present, a=test_absent, model=glm_model,
                     x=bioclim_hist_local)

#Find the maximum kappa threshold
max_kappa <- plogis(threshold(glm_eval, stat='kappa'))
print(max_kappa)

#look at some model performmance plots
par(mfrow= c(1,2), mar=c(1,2,2,1))

#ROC curve and kappa by model threshold
plot(glm_eval, 'ROC', type = 'l')
plot(glm_eval, 'kappa', type ='l')
abline(v=max_kappa, lty=2, col='blue')

#Species distribution
par(mfrow=c(2,2))
#Modelled probability
plot(glm_pred, col=hcl.colors(20, 'Blue-Red'))
#Threshold map
glm_map <- glm_pred >=max_kappa
plot(glm_map, legend=FALSE, col=c('grey','red'))

#Future predictions
glm_pred_2050 <- predict(bioclim_2050_local, glm_model, type='response')
plot(glm_pred_2050, col=hcl.colors(20,'Blue-Red'))

#Threshold map
glm_map_2050 <- glm_pred_2050 >= max_kappa
plot(glm_map_2050, legend = FALSE, col=c('grey', 'red'))

#Simple way to described the modelled changes
table(values(glm_map), values(glm_map_2050), dnn=c('hist', '2050'))
