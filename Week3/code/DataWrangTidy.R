################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <-as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
str(MyData)
fix(MyData) #you can also do this
fix(MyMetaData)


############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData)
head(MyData)
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

MyData <- MyData %>% replace_na(0)

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data
rownames(TempData) <- NULL #get rid of the row names created by default
head(TempData)

############# Convert from wide to long format  ###############
require(tidyverse) # load the tidyverse package

MyWrangledData <- gather(TempData, key = "Species", value = "Count", "Achillea millefolium":"Vulpia myuros ", factor_key = TRUE)

head(MyWrangledData);tail(MyWrangledData) 

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data (extend the script below)  ###############

#covert the dataframe to a "tibble"
#tibble in tidyverse is equivalent to R's data.frame 
#but make data exploration easier

tibble::as_tibble(MyWrangledData) 

dplyr::glimpse(MyWrangledData) # like str(), but nicer!

dplyr::filter(MyWrangledData, Count > 100)

dplyr::slice(MyWrangledData, 10:15) # look at an arbitrary set of data rows


