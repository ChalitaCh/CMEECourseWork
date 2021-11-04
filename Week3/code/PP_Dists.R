#Visualising the distribution of the Prey and Predator masses

#Author: Chalita Chomkatekaew (chalita.chomkatekaew20@ic.ac.uk)
#version: 0.0.1

#Clean everything
rm(list = ls())

#Load a required package

require(ggplot2)
require(tidyverse)
require(viridisLite)
require(viridis)

#load dataset

MyDF <- read.csv("../data/EcolArchives-E089-51-D1.csv")

#Set the variables to act as a factor i.e categorical

MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)

#ratio between the log prey mass over log predator mass


MyDF$logPrey.mass <- log(MyDF$Prey.mass)
MyDF$logPredator.mass <- log(MyDF$Predator.mass)
MyDF$ratioPreyPredator <- MyDF$logPrey.mass/MyDF$logPredator.mass

#plot distribution of Log Prey Mass

Prey <- ggplot(MyDF, aes(x = logPrey.mass, fill = Type.of.feeding.interaction)) +
  geom_density(adjust = 1.5) +
  scale_fill_viridis(discrete = TRUE) +
  scale_x_continuous(labels = function(x) format(x, scientific = TRUE)) +
  scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) +
  facet_grid(Type.of.feeding.interaction~.) +
  theme_bw() +
  xlab("Log Prey Mass (g)") +
  ylab("Density") +
  theme(legend.position = "none")

#plot distribution of Log Predator Mass

Pred <- ggplot(MyDF, aes(x = logPredator.mass, fill = Type.of.feeding.interaction)) +
  geom_density(adjust = 1.5) +
  scale_fill_viridis(discrete = TRUE) +
  scale_x_continuous(labels = function(x) format(x, scientific = TRUE)) +
  scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) +
  facet_grid(Type.of.feeding.interaction~.) +
  theme_bw() +
  xlab("Log Pretator Mass (g)") +
  ylab("Density") +
  theme(legend.position = "none")

#plot the distribution of the ratio btw them

Ratio <- ggplot(MyDF, aes(x = ratioPreyPredator, fill = Type.of.feeding.interaction)) +
  geom_density(adjust = 1.5) +
  scale_fill_viridis(discrete = TRUE) +
  scale_x_continuous(labels = function(x) format(x, scientific = TRUE)) +
  scale_y_continuous(labels = function(x) format(x, scientific = TRUE)) +
  facet_grid(Type.of.feeding.interaction~.) +
  theme_bw() +
  xlab("Ratio of Log Prey Mass/Log Predator Mass") +
  ylab("Density") +
  theme(legend.position = "none")

#summarise the mean and median of different feeding types 

Summary_stats <- MyDF %>%
  group_by(Type.of.feeding.interaction) %>%
  summarise_at(
    .vars = c("logPrey.mass", "logPredator.mass", "ratioPreyPredator"),
    .funs = list(mean = mean, median = median),
    .names = "{var}_{fun}")

#Rename the columns to the appropriate headers
colnames(Summary_stats) <- c("Feeding.Type", "LogPreyMass.mean", 
                             "LogPredatorMass.mean", "ratioPreyPredator.mean",
                             "LogPreyMass.median", "LogPredatorMass.median", 
                             "ratioPreyPredator.medain")

#save the plots and statistics summary to the results directory

write.csv(Summary_stats, "../results/PP_Results.csv", row.names = FALSE)

ggsave("../results/Prey_Subplots.pdf", plot = Prey ,
       width = 21.0, height = 29.7, units = "cm")

ggsave("../results/Predator_Subplot.pdf", plot = Pred ,
       width = 21.0, height = 29.7, units = "cm")

ggsave("../results/SizeRatio_Subplot.pdf", plot = Pred ,
       width = 21.0, height = 29.7, units = "cm")
