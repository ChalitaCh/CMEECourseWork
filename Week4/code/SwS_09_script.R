## SwS 09 ##
# Exercises:
# Upload one word document per group
# 1)	Discuss the questions above with your group, until you find 
#       satisfactory answers.
# 2)	Run a linear model, where you test the hypothesis that sparrows with 
#     bigger bills can eat more. The prediction is that the larger the bill, 
#     the heavier the sparrow.
# Detail what your explanatory and what your response variable is. Write a short (1A4) report on methods and results per group.
#Before you go into the linear model, you should first describe your data, say how many sparrows, how many females and males, whether there is a difference in your response between the sexes. If that difference is meaningful, you should test the sexes separately. Write this section as you would write it for a scientific article. Discuss in the group what should go into the report, and what not. Submit one report per group.
getwd()
setwd("/cloud/project/SwS_09_workspace")
d<-read.table("SparrowSize.txt", header=TRUE)

plot(d$Mass~d$Bill, ylab="Mass (g)", xlab="Bill (mm)", pch=19, cex=0.4)
d1<-subset(d, d$Mass!="NA")
d2<-subset(d1, d1$Bill!="NA")
length(d2$Tarsus)
model1<-lm(Mass~Bill, data=d2)
summary(model1)

hist(model1$residuals)
install.packages("ggplot2")
library(ggplot2)
#intercept is mass for female because f is before m. Bill is 0.9 which is the slope for female, for every 1mm increase in bill mass increases by 0.9 mass. The slope is sign so there is a sig interaction between mass and bill
#2.6 is the intercept for males, to work out slope of male line its 0.9+-0.16= 0.74, this is the slope of the male (0.93-0.74), so for every 1mm increase in bill size in males we get 0.74 increase in mass.
0.9+-0.16
#Bill:sex- this is how much the male and female lines differ, its only -0.16 different
#to work out slope of 
#We can  now predict mass if we know bill length
billplot<-qplot(x=Bill, y=Mass, data=d2, colour=Sex.1)+geom_smooth(method="lm")+geom_point()

billplot

##########################################################################

> summary(model1)

Call:
  lm(formula = Mass ~ Bill * Sex, data = d2)

Residuals:
  Min      1Q  Median      3Q     Max 
-6.0465 -1.4233 -0.1997  1.1356  8.5302 

Coefficients:
  Estimate Std. Error t value Pr(>|t|)    
(Intercept)  14.9791     1.8880   7.934 5.17e-15 ***
  Bill          0.9331     0.1414   6.597 6.48e-11 ***
  Sex           2.6777     2.6376   1.015    0.310    
Bill:Sex     -0.1630     0.1980  -0.823    0.411    
---
  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.966 on 1107 degrees of freedom
Multiple R-squared:  0.07502,	Adjusted R-squared:  0.07251 
F-statistic: 29.93 on 3 and 1107 DF,  p-value: < 2.2e-16
