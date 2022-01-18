#### SwS 02 ####

# Welcome - this is your workspace for hand out SwS 02 #

# Please first work through the hand out using this script #
# Nothing needs to be submitted #

getwd()
setwd("../SwS02")

d <- read.table("SparrowSize.txt", header = TRUE)
str(d)

hist(d$Tarsus)
mean(d$Tarsus, na.rm = TRUE)

median(d$Tarsus, na.rm = TRUE)

mode(d$Tarsus)

par(mfrow = c(2, 2))
hist(d$Tarsus, breaks = 3, col="grey")
hist(d$Tarsus, breaks = 10, col = "grey")
hist(d$Tarsus, breaks = 30, col = "grey")
hist(d$Tarsus, breaks = 100, col = "grey")

head(table(d$Tarsus))

d$Tarsus.rounded <- round(d$Tarsus, digits = 1)
head(d$Tarsus.rounded)

require(dplyr)

TarsusTally <- d %>% count(Tarsus.rounded, sort = TRUE)
d2 <- subset(d, d$Tarsus!="NA")
length(d$Tarsus)-length(d2$Tarsus)

TarsusTally <- d2 %>% count(Tarsus.rounded, sort = TRUE)
TarsusTally[[1]][1]

range(d2$Tarsus, na.rm = TRUE)

sqrt(var(d2$Tarsus))

zTarsus <- (d2$Tarsus - mean(d2$Tarsus))/sd(d2$Tarsus)

sd(zTarsus)

hist(zTarsus)

znormal <- rnorm(1e+06)
hist(znormal, breaks = 100)
summary(znormal)

par(mfrow = c(1,2))
hist(znormal, breaks = 100)
abline(v=qnorm(c(0.25, 0.5, 0.75)), lwd = 2)
abline(v=qnorm(c(0.025, 0.975)), lwd =2, lty = "dashed")

plot(density(znormal))
abline(v=qnorm(c(0.25, 0.5, 0.75)), col = "gray")
abline(v=qnorm(c(0.025, 0.975)), col = "black", lty = "dotted")
abline(h = 0, lwd = 3, col = "blue")
text(2, 0.3, "1.96", col = "red", adj = 0)
text(-2, 0.3, "-1.96", col = "red", adj = 0)
