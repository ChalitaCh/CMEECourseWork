#### SwS 01 ####

# Welcome - this is your workspace for hand out SwS 01 #

# Please first work through the hand out using this script #

## Then work in groups to solve the following tasks in this script at first.
## When you have agreed on a solution, make a final solution script for the 
## below and hand that in with your word document. One script and one word 
## document per group.


# 1.	How many repeats are there per bird per year? 
# 2.	How many individuals did we capture per year for each 
#     sex? Compute the numbers, devise a useful table format, and 
#     fill it in.
# 3.	Think about how you can communicate (1) and (2) best 
#     in tables, and how you can visualise (1) and (2) using plots. 
#     Produce several solutions, and discuss in the group which 
#     the pros and cons for each solution to communicate and 
#     visualize the data structure for (1) and (2). 
# 4.	Write and submit two results sections for (1) and (2). 
#     Each result section should use different means of communicating 
#     the results, visually and in a table. Submit 1 word document, and 
#     1 script per group.


rm(list=ls())

#Set the directory
getwd()
setwd("/Users/chalitachomkatekaew/Documents/CMEE/Week4_Stat_in_R/SwS01Workspace/")

#Load the dataset

DF <- read.table("SparrowSize.txt", header = TRUE)

#Packages
#install.packages("tidyverse")
#install.packages("viridis")
require(ggplot2)
require(tidyverse)
require(viridisLite)
require(viridis)

#Exercise
# 1.	How many repeats are there per bird per year? 

CountBirdYear <- DF %>% group_by(Year) %>% count(BirdID)


# 2.	How many individuals did we capture per year for each 
#     sex? Compute the numbers, devise a useful table format, and 
#     fill it in.

TotalYearSex <- with(DF, table(Year, Sex.1))
TotalYearSex <- as.data.frame.table(TotalYearSex)
TotalYearSex$Sex.1 <- as.factor(TotalYearSex$Sex.1)

# 3.	Think about how you can communicate (1) and (2) best 
#     in tables, and how you can visualise (1) and (2) using plots. 
#     Produce several solutions, and discuss in the group which 
#     the pros and cons for each solution to communicate and 
#     visualize the data structure for (1) and (2).

## Visualised data from exercise 1

plot1 <- CountBirdYear %>%
  ggplot(aes(x = BirdID, y = n, fill = as.factor(Year))) +
  geom_bar(stat = 'identity') +
  theme_bw()+
  theme(legend.position = 'none') +
  ylab("Number of repeated") +
  facet_wrap(.~ Year)

plot1

## Visualised data from exercise 2

plot2 <- TotalYearSex %>% ggplot(aes(x= Year, y=Freq, fill=Sex.1)) +
  geom_bar(stat = 'identity', position = 'dodge2') +
  scale_fill_viridis(discrete = TRUE, option = 'cividis')+
  ylab("Frequency")+
  theme_bw()+
  theme(aspect.ratio = 1)
  

plot2
# 4.	Write and submit two results sections for (1) and (2). 
#     Each result section should use different means of communicating 
#     the results, visually and in a table. Submit 1 word document, and 
#     1 script per group.

#Overall distribution of each year
ggplot(DF, aes(x = Year)) +
  geom_histogram()+
  scale_x_continuous(breaks = seq(2000, 2010, 1))