#### SwS 04 ####

# Welcome - this is your workspace for hand out SwS 04 #

# Please  work through the hand out using this script #
# Nothing needs to be submitted #


# Note: These exercises are intended to improve your understanding of the statistics, the functions, and improve your ability to problem solve and code.
# 1) Calculate the standard error of Tarsus, Mass, Wing and Bill length of the complete population sample (as opposed to all sparrows in this world) Note N of each. Then, subset the dataset to only 2001 data d1<-subset(d, d$Year==2001), as we did in the lecture. Calculate SE for Tarsus, Mass, Wing and Bill length for the 2001 sample. Calculate the 95% CI for each mean.
# 2) Play around with the last plot we made. Change the values of the simulation. Change the mean, the standard deviation to other values, and see how it affects your plot. Just try out various combinations! This should help you to get better at
# -	Understanding how mean and SE and sample size are linked
# -	Understanding how to plot things in R
# -	Understanding how to use for loops in R
# -	Understanding how to make, access and use variables, vectors and data frames in R
# Note: it is ok if you find this difficult. This is something that you need to do, and do again, and redo again, and the more often you practice this the better you will become at understanding it. So use this time to repeat and practice. 
# Non-compulsory:
#   3) If you found the above easy and want to test out your coding and stats skills, this is a task for you. 
# Sample mass of the whole sparrow dataset. Then produce a plot to see at what sample size the standard error become so small that you’d be confident to get a reasonably precise mean - precise with respect to the grand total mean of the whole dataset. (The next part is rather philosophical). Then look at sample sizes in different years and think about what sort of biological questions one could answer with one year’s data, and what not. 

rm(list = ls())
d <- read.table("SparrowSize.txt", header = TRUE)
d1 <- subset(d, d$Tarsus!="NA")
seTarsus <- sqrt(var(d1$Tarsus)/length(d1$Tarsus))
seTarsus

d12001 <- subset(d1, d1$Year == 2001)
seTarsus2001 <- sqrt(var(d12001$Tarsus)/length(d12001$Tarsus))
seTarsus2001

rm(list=ls())
TailLength <- rnorm(201, mean = 3.8, sd=2)
summary(TailLength)
hist(TailLength)

x <- 1:length(TailLength)
y <- mean(TailLength) + 0*x

min(TailLength)

max(TailLength)

plot(x, y, cex= 0.03, ylim=c(3, 4.5), xlim=c(0,201),
     xlab ="Sample size n",
     ylab = "Mean of tail length ±SE (m)",
     col = "red")
n <- seq(from =1, to = 201, by= 10)
SE <- c(1)
mu <- c(1)
for (i in 1:length(n)) {
  d <- sample(TailLength, n[i], replace = FALSE)
  mu[i] <- mean(TailLength)
  SE[i] <- sd(TailLength)/sqrt(n[i])
}

up <- mu + SE
down <- mu - SE
length(up)

plot(x, y, cex = 0.03, ylim = c(3, 4.5), xlim=c(0,201),
     xlab = "Sample size n",
     ylab = "Mean of tail length ±SE (m)",
     col = "red")
points(n, mu, cex=0.3, col = "red")
segments(n, up, x1=n, y1=down, lty=1)
