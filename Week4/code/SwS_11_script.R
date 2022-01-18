## SwS_11 ##

rm(list = ls())

getwd()
setwd("/Users/chalitachomkatekaew/Documents/CMEE/Week4_Stat_in_R/SwS11_Workspace/")

daphnia <- read.delim("daphnia.txt")
summary(daphnia)
head(daphnia)

par(mfrow = c(1, 2))
par(mar = c(3, 3, 3, 3))
plot(Growth.rate ~ as.factor(Detergent), data = daphnia)
plot(Growth.rate ~ as.factor(Daphnia), data = daphnia)
dev.off()

require(dplyr)

daphnia %>% 
  group_by(Detergent) %>%
  summarise(variance= var(Growth.rate))

daphnia %>%
  group_by(Daphnia) %>%
  summarise(variance = var(Growth.rate))

hist(daphnia$Growth.rate)

seFun <- function(x) {
  sqrt(var(x)/length(x))
}

detergentMean <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
                                      FUN = mean))
detergentSEM <- with(daphnia, tapply(Growth.rate, INDEX = Detergent,
                                     FUN = seFun))

cloneMean <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia,
                                      FUN = mean))
cloneSEM <- with(daphnia, tapply(Growth.rate, INDEX = Daphnia,
                                      FUN = seFun))

par(mfrow = c(2,1), mar = c(4, 4, 1,1))
barMids <- barplot(detergentMean, xlab = "Detergent type",
                   ylab = "Population growth rate",
                   ylim = c(0, 5))

arrows(barMids, detergentMean - detergentSEM, barMids, detergentMean+ detergentSEM,
       code = 3, angle = 90)

barMids2 <- barplot(cloneMean, xlab = "Daphnia clone",
                   ylab = "Population growth rate",
                   ylim = c(0, 5))

arrows(barMids2, cloneMean - cloneSEM, barMids2, cloneMean + cloneSEM,
       code = 3, angle = 90)

daphniaMod <- lm(Growth.rate ~ Detergent + Daphnia, data = daphnia)
summary(daphniaMod)

timber <- read.delim("timber.txt")
summary(timber)

t2<-as.data.frame(subset(timber, timber$volume!="NA"))
t2$z.girth<-scale(timber$girth)
t2$z.height<-scale(timber$height)

pairs(timber)
