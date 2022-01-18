## SwS 06 ##
rm(list=ls())

install.packages("WebPower")

require(WebPower)
?WebPower

0.3/1.2

y <- rnorm(51, mean = 1, sd = 1.3)
x <- seq(from = 0, to = 5, by = 0.1)

plot(hist(y, breaks=10))

mean(y)
sd(y)

segments(x0=(mean(y)), y0=(0), x1=(mean(y)), y1= 40, lty=1, col ="blue")

segments(x0 = (mean(y) + 0.25*sd(y)), y0=(0), x1=(mean(y) + 0.25*sd(y)), y1=40, lty=1, col = "red")

wp.t(d=0.25, power = 0.8, type = "two.sample", 
     alternative = "two.sided" )

res.1 <- wp.t(n1 = seq(20, 300,20), n2=seq(20, 300, 20),
              d=0.25, type = "two.sample",
              alternative = "two.sided")

res.1

plot(res.1, xvar = 'n', yvar = 'power')
# Exercises (submit one word document per group):
#   1.	You are given a dataset by your PI, where an experiment has been 
#       performed where the growth of two groups of bacterial colonies (n each 
#       group = 300) has been compared. Your PI has found an interesting 
#       difference between both groups - to an effect size of 0.11, with a 
#       p = 0.044. The result is rather ground breaking, but the PI is worried 
#       that it might be a misleading result. The PI didn’t do a statistical 
#       power analysis, so they are uncertain about whether they had sufficient
#       power. The bacterial colonies have since died, because nobody could 
#       enter the lab for months due to a pandemic. Hence, to repeat the 
#       experiment would be very expensive and time consuming. Calculate the 
#       statistical power of this test. Then discuss in your group what the 
#       result means and how the PI should proceed.

wp.t(n1 = 300, n2 = 300, d = 0.11, type = "two.sample",
     alternative = "two.sided")

#   
#   2.	Write up a methods section that details what you have done and 
#       justifies your decisions. Then write a results section that details 
#       your results, and use tables and/or graphs to support your points. 
#       Then write up a conclusion section, where you must make one suggestion 
#       of how, and why, the PI should proceed. Submit one word document per 
#       group. 
#   
#   3.	Philosophical discourse: In your groups, discuss what the consequence 
#       of Type I and Type II errors are for the body of published literatures.
#       If one in twenty results may be a false positive or negative, then what 
#       does that mean for the whole body of literature? Discuss repercussions
#       and potential solutions. 
#   
#   