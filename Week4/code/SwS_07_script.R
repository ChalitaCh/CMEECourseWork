## SwS 07 ###
# Exercises
# nothing to upload. Individual work. Feel free to discuss in groups. 
# 1) The response variable (y) is body mass in kg of Romanian Longhorn dragons. 
#    The explanatory variable (x) is the amount of sheep they’ve eaten in the 
#    last hour. The slope is 12. You don’t know the intercept (but you don’t 
#    need to know it to answer this question). How much kg does a Longhorn 
#    dragon gain on average per sheep eaten in the last hour?
x <- seq(from = 0, to = 20, by = 1)
b<-12
y <- x*12
plot(x,y)

# 2)	The slope is 8, and the intercept is 0. This relationship describes 
#    the number of new moth species in my garden per day of catching in July. 
#    How many species can I expect to have seen after catching 10 days in July?
x<-seq(from = 1, to = 30, by = 0.1)
a<-0
b<-8
y<-a+b*x
plot(x,y)
segments(0, 10,0 ,-10, lty = 3)
#it goes up 8 for every one
x = 10
y = 10*8
# 3)	The quadratic relationship y=-1+2x-0.15x^2 describes how a phoenix’s’ 
#    reproductive success first improves with age (in years), and then declines 
#    as they age. At what age are these birds in their prime year? How many
#    offspring do they produce at their prime, before reproductive output 
#    starts declining again?
y<--1+2*x-0.15*x^2
#or
x = seq(0, 50, 1)#make a seq of age
y = (-1+(2*x)-(0.15*(x^2)))
plot(x, y)
max(y)
prime <- x[which(y == 5.65)]
#the birds are in their prime aged 7
#they produce approximately 5.65 offspring in their prime, which if rounded to 
#an integer is 6 bc you can't have half a baby
# 4)	You tested for the relationship between nature reserve area 
#    (explanatory variable, in ha), and species richness (in number of 
#    species). You find a linear slope b1 of 2, a quadratic slope b2 of -0.08, 
#    and an intercept of -1. Describe the change of the number of species seen 
#    as reserve area size changes.

plot(x,y)
a<- -1
b1<- 2
b2<--0.8
y<-a+b1*x+b2*x^2

x = seq(0, 50, 0.5)
y = (-1+(2*x)-(0.08*(x^2)))
plot(x, y)
#the species richness increases with RA area, until 12.5ha after which it 
#decreases, and falls to 0 after 24 ha.
# 5) Finish the ho.07.SwS.Linear Functions Exit Quiz before proceeding to 
#    the next lecture. It’s on blackboard, PG Life Science Core Skills Modules 
#    2020-2021, week 4, Tuesday, ho.07.SwS.Linear Functions Exit Quiz.
