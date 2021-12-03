rm(list = ls())
#setwd("CMEECourseWork/Miniproject/code/")
#load the require package

require(tidyverse)

#load the optimised parameters values

parameters <- read.csv("../results/Fitted_parameters.csv")
data_raw <- read.csv("../results/GrowthDataClean.csv")

n <- length(unique(data_raw$ID))

fit_stats <- data.frame(ID = rep(NA, n),
                        Species = rep(NA, n),
                        Temp = rep(NA, n),
                        PopBio_units = rep(NA, n),
                        Medium = rep(NA, n),
                        Rep = rep(NA, n),
                        N = rep(NA, n),
                        Citation = rep(NA, n))


for (i in 1:n){
  subsetdata <- subset(data_raw, data_raw$ID == i)
  fit_stats[i,] <- c(subsetdata$ID[1],
                     subsetdata$Species[1],
                     subsetdata$Temp[1],
                     subsetdata$PopBio_units[1],
                     subsetdata$Medium[1],
                     subsetdata$Rep[1],
                     length(subsetdata$ID),
                     subsetdata$Citation[1])
}

new_data <- merge(fit_stats,parameters, by = "ID")
new_data$ID <- as.numeric(new_data$ID)
new_data <- new_data[order(new_data$ID),]

#remove rows containing the NA from the further analyses

new_data[new_data == -Inf] <- NA

fit_stats_clean <- new_data[complete.cases(new_data), ]

#find the best model for each group; goodness of fit

#Calculate the AICc scores andt the normalised probability of Weight Akaike

#Select the specific columns for calculation

names_AIC <- c("ID","N", "GomAIC", "LogAIC",
           "Qua_AIC","Cubic_AIC")

model_AIC <- fit_stats_clean[,names_AIC]

#Ensure that the values are set as numeric

model_AIC$N <- as.numeric(model_AIC$N)
model_AIC$GomAIC <- as.numeric(model_AIC$GomAIC)
model_AIC$LogAIC <- as.numeric(model_AIC$LogAIC)
model_AIC$Qua_AIC <- as.numeric(model_AIC$Qua_AIC)
model_AIC$Cubic_AIC <- as.numeric(model_AIC$Cubic_AIC)


#Define a function to calculate the AICc 
#The parameters are defined as
# 
# AIC = the AIC score from the best model
# k = number of parameters in each model tested
# n = number of raw datapoints

AICc <- function(AIC, k, n){
  AIC_c = AIC + (2 * k * (k + 1))/(n - k - 1)
  return(AIC_c)
}


#Calculate the AICc for every model

for (i in 1:nrow(model_AIC)){
  model_AIC$GomAICc[i] <- AICc(AIC = model_AIC$GomAIC[i],
                          k = 4,
                          n = model_AIC$N[i])
  model_AIC$LogAICc[i] <- AICc(AIC = model_AIC$LogAIC[i],
                            k = 3,
                            n = model_AIC$N[i])
  model_AIC$Qua_AICc[i] <- AICc(AIC = model_AIC$Qua_AIC[i],
                            k = 3,
                            n = model_AIC$N[i])
  model_AIC$Cubic_AICc[i] <- AICc(AIC = model_AIC$Cubic_AIC[i],
                            k = 4,
                            n = model_AIC$N[i])
  
}

#Find out which model has the lowest AICc and get the value of that AICc

model_AIC <- model_AIC %>%
  pivot_longer(cols = -c(1:6)) %>%
  group_by(ID) %>%
  summarise(MinModel = name[which.min(value)]) %>%
  left_join(model_AIC, .) %>%
  mutate(MinValue = apply(model_AIC[,c("GomAICc", "LogAICc", "Qua_AICc", "Cubic_AICc")], 1, FUN = min))

# weight_AIC <- function(diffmodel, diffgom, difflog, diffqua, diffcubic){
#   W = exp(-diffmodel/2) / exp(-diffgom/2) + exp(-difflog/2) + exp(-diffqua/2) + exp(-diffcubic/2)
#   return(W)
# }

model_AIC[model_AIC == Inf] <- NA #Remove sample with Inf scores to ensure correct calculation
model_AIC <- model_AIC[complete.cases(model_AIC), ] #Remove any NAs

for (i in 1:nrow(model_AIC)){
  #Find the delta AICc, when compared with the model with lowest AIC
  model_AIC$diffGom[i] <- model_AIC$GomAICc[i] - model_AIC$MinValue[i] 
  model_AIC$diffLog[i] <- model_AIC$LogAICc[i] - model_AIC$MinValue[i]
  model_AIC$diffQua[i] <- model_AIC$Qua_AICc[i] - model_AIC$MinValue[i]
  model_AIC$diffCubic[i] <- model_AIC$Cubic_AICc[i] - model_AIC$MinValue[i]
  
  #Calculate the relative likehood of each model
  
  model_AIC$wi_Gom[i] <- exp(-0.5 * model_AIC$diffGom[i]) 
  model_AIC$wi_Log[i] <- exp(-0.5 * model_AIC$diffLog[i])
  model_AIC$wi_Qua[i] <- exp(-0.5 * model_AIC$diffQua[i])
  model_AIC$wi_Cubic[i] <- exp(-0.5 * model_AIC$diffCubic[i])
  
  #Calculate the Weight Akaike of each model
  
  model_AIC$aic_wi_Gom[i] <- model_AIC$wi_Gom[i]/sum(model_AIC[i, c("wi_Gom","wi_Log","wi_Qua","wi_Cubic")])
  model_AIC$aic_wi_Log[i] <- model_AIC$wi_Log[i]/sum(model_AIC[i, c("wi_Gom","wi_Log","wi_Qua","wi_Cubic")])
  model_AIC$aic_wi_Qua[i] <- model_AIC$wi_Qua[i]/sum(model_AIC[i, c("wi_Gom","wi_Log","wi_Qua","wi_Cubic")])
  model_AIC$aic_wi_Cubic[i] <- model_AIC$wi_Cubic[i]/sum(model_AIC[i, c("wi_Gom","wi_Log","wi_Qua","wi_Cubic")])
  
}

#Select the models with the highest probability

model_AIC_final <- model_AIC %>%
  pivot_longer(cols = -c(1:20)) %>%
  group_by(ID) %>%
  summarise(Weight_Model = name[which.max(value)],
            best = max(value),
            second_best = max(value[-which.max(value)])) %>%
  left_join(model_AIC, .) 


#Change the naming of the model

model_AIC_final$Weight_Model[model_AIC_final$Weight_Model == "aic_wi_Gom"] <- "Gompertz"
model_AIC_final$Weight_Model[model_AIC_final$Weight_Model == "aic_wi_Log"] <- "Logistic"
model_AIC_final$Weight_Model[model_AIC_final$Weight_Model == "aic_wi_Qua"] <- "Quadratic"
model_AIC_final$Weight_Model[model_AIC_final$Weight_Model == "aic_wi_Cubic"] <- "Cubic"

#Calculate the normalised probability that the selected model is better than the second best

for (i in 1:nrow(model_AIC_final)){
  model_AIC_final$normal_prob[i] <- model_AIC_final$best[i]/(model_AIC_final$second_best[i] + model_AIC_final$best[i])
}

#selected only the named column and combine with metadata

names_final <- c("ID", "GomAICc", "LogAICc", "Qua_AICc", "Cubic_AICc","MinValue","Weight_Model","normal_prob")

model_AIC_final <- model_AIC_final[,names_final]

data_subset <- fit_stats_clean[,c("ID","Species","Temp","Medium","Citation", "GomBIC","LogBIC", "Qua_BIC","Cubic_BIC")]

results <- merge(data_subset, model_AIC_final, by = "ID")
results$Temp <- as.numeric(results$Temp)


#Explore the data

#For each temperature bin

Temp_model_AIC <- results %>% 
  mutate(Temperature = cut_width(Temp, width = 10, boundary = 0)) %>%
  group_by(Temperature) %>%
  summarise(N = n(),
            MeanGAICc = round(mean(GomAICc),digits = 3),
            MeanLAICc = round(mean(LogAICc),digits = 3),
            MeanQAIC = round(mean(Qua_AICc),digits = 3),
            MeanCAIC = round(mean(Cubic_AICc),digits = 3)) %>%
  as.data.frame()

Temp_model_AIC$Temperature <- c("0-10","11-20", "21-30", "31-40")

write.csv(Temp_model_AIC, "../results/Temp_models.csv", quote = FALSE, row.names = FALSE)


#Summarise the AICc and BIC values for tested growth curves

model_AIC_sum <- results %>%
  group_by(Weight_Model) %>%
  summarise(MeanProb = round(mean(normal_prob),digits = 3),
            MinProb= round(min(normal_prob), digits = 3),
            MaxProb= round(max(normal_prob), digits = 3),
            N.AIC = n()) %>%
  as.data.frame()

model_AIC_sum$MeanAICc <- c(mean(results$Cubic_AICc),
                         mean(results$GomAICc),
                         mean(results$LogAICc),
                         mean(results$Qua_AICc))
model_AIC_sum$MeanAICc <- round(model_AIC_sum$MeanAICc, digits = 3)

names(model_AIC_sum)[names(model_AIC_sum) == "Weight_Model"] <- "Models"

names_BIC <- c("ID","GomBIC", "LogBIC","Qua_BIC", "Cubic_BIC")

model_BIC <- fit_stats_clean[,names_BIC]
model_BIC <- model_BIC %>%
  pivot_longer(cols = -c(1)) %>%
  group_by(ID) %>%
  summarise(MinModel_BIC = name[which.min(value)]) %>%
  left_join(model_BIC, .) 

MeanBIC <- c(mean(model_BIC$Cubic_BIC), mean(model_BIC$GomBIC), mean(model_BIC$LogBIC),
             mean(model_BIC$Qua_BIC))

model_BIC_sum <- model_BIC %>%
  group_by(MinModel_BIC) %>%
  count() %>%
  mutate(MinModel_BIC = str_replace(MinModel_BIC, "Cubic_BIC","Cubic"),
         MinModel_BIC = str_replace(MinModel_BIC, "Qua_BIC","Quadratic"),
         MinModel_BIC = str_replace(MinModel_BIC, "GomBIC","Gompertz"),
         MinModel_BIC = str_replace(MinModel_BIC, "LogBIC","Logistic"))

names(model_BIC_sum)[names(model_BIC_sum) == "MinModel_BIC"] <- "Models"
names(model_BIC_sum)[names(model_BIC_sum) == "n"] <- "N.BIC"

model_BIC_sum$MeanBIC <- round(MeanBIC, digits = 3)

Overall_models <- merge(model_AIC_sum, model_BIC_sum, by = "Models")

col_order <- c("Models", "N.AIC","N.BIC", "MeanAICc","MeanBIC", "MeanProb","MinProb","MaxProb")
Overall_models<- Overall_models[, col_order]

write.csv(Overall_models, "../results/Overall_models.csv", quote = FALSE,row.names = FALSE)

#save as a csv file for more data visualisation

write.csv(results, "../results/GrowthStatSummary.csv", row.names =  FALSE)






