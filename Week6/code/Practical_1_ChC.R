##Genomic practical 1
##Date 8/11/21

##Set the working directory

setwd("/Users/chalitachomkatekaew/Documents/CMEE/Week6_genomics/")

##require package

require(tidyverse)
require(ggplot2)
require(reshape2)

##Import dataset

bear <- read.csv("bears.csv", stringsAsFactors = FALSE, header = FALSE,
                 colClasses = rep("character", 10000))

#Identify which position are SNPs and store it in a new dataframe

test <- bear %>%
  select_if(function(col) length(unique(col))>1)

#Calculate, print and visualise allele frequencies for each SNP

#Create a frequency table of each positions

dt_freq = data.frame()

for (i in 1:ncol(test)){
  
  dt_temp = data.frame(t(table(test[,i])))
  dt_temp$Var1 = names(test)[i]
  
  dt_freq = rbind(dt_freq, dt_temp)
  
}


#Rename the columns
names(dt_freq) <- c("Position","Allele","Frequency")

#Calculate the frequency of each SNP in the population ; 20 individuals and 40 DNA sequences

new_df <- dt_freq %>% 
  mutate(Allele.freq = Frequency/40) %>%
  mutate(Position.new = as.factor(str_remove(.$Position,'[V]'))) #remove V out and make a new position column as a factor

sorted_labels <- paste(sort(as.integer(levels(new_df$Position.new)))) #sort and reorder the nucleotide postion
new_df$Position.new <- factor(new_df$Position.new, levels = sorted_labels) #set the level of the position to the sorted one

Freq <- new_df %>%
  ggplot(aes(x= Position.new, y = Allele.freq, fill = as.factor(Allele))) +
  geom_bar(stat = 'identity',width=.5, position = 'dodge') +
  theme(axis.text.x = element_text(angle = 90))

Freq

ggplot(data = new_df, aes(x= Allele.freq)) +
  geom_histogram(stat = "bin")

#Calculate and print genotype frequency for each SNP

#group every 2 rows together - as one individual has 2 DNA sequences
test_temp <-  bear %>%
  mutate(individual_index = rep(1:(nrow(test)/2), each = 2))

genotype <- test_temp %>%
  group_by(individual_index) %>%
  summarise(
    across(
      .cols = everything(),
      .fns = ~count(unique(.)),
      .names = "{col}_new"
    )
  )




