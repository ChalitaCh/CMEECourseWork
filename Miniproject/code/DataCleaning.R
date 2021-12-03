#load require packages
require(tidyverse)

#load the data
data <- read.csv("../data/LogisticGrowthData.csv")

#remove the row number out

data <- data[-1]

#Create the unique ID and the number ID
data <- data %>%
  unite("Unique_ID", c("Species", "Medium", "Temp", "Citation"), 
       sep = "_", remove = FALSE)

#Create a numeric ID representing the unique combination of the Unique_ID created previously

data <- data %>%
  group_by(Unique_ID) %>%
  mutate(ID = cur_group_id())

#sort the data frame 

col_order <- c("ID", "Unique_ID", "Species", "Time", "PopBio", "Time_units",
               "PopBio_units", "Temp", "Medium", "Rep", "Citation")

data <- data[order(data$ID),] #reorder the rows by the ID
data <- data[, col_order] #reorder the columns by the col_order


#Checking if any time value is negative and remove the negative values
# 
# n <- length(unique(data$ID))
#length(which(data_clean$Time < 0))# 68 entries have negative value of time

#length(which(data_clean$PopBio < 0))

data_clean <- subset(data, data$Time > 0) #remove any row with time less than 0

data_clean <- subset(data_clean, data_clean$PopBio > 0) #remove any row with abundance less than 0

#export the data out

write.csv(data_clean, "../results/GrowthDataClean.csv", row.names = FALSE)




