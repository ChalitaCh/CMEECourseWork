# Mathematical display

#Author: Chalita Chomkatekaew (chalita.chomkatekaew20@ic.ac.uk)
#version: 0.0.1

#Load a required package

require(ggplot2)

#Create a dataset

x <- seq(0,100, by = 0.1)
y <- -4. + 0.25* x +
  rnorm(length(x), mean = 0., sd = 2.5)

# and put them in a dataframe

my_data <- data.frame(x = x, y = y)

# perform a linear regression

my_lm <- summary(lm(y~x, data = my_data))

# plot the data
p <- ggplot(my_data, aes(x =x, y =y,
                         colour = abs(my_lm$residuals))
            )+
  geom_point() +
  scale_colour_gradient(low = "black", high = "red")+
  theme(legend.position = "none")+
  scale_x_continuous(
    expression(alpha^2 * pi/ beta * sqrt(Theta))
  )

# add the regression line

p <- p + geom_abline(
  intercept = my_lm$coefficients[1][1],
  slope = my_lm$coefficients[2][1],
  colour = "red"
)

#throw some math on the plot

p <- p + geom_text(aes (x= 60, y =0,
                        label = "sqrt(alpha) * 2 * pi"),
                   parse = TRUE, size = 6,
                   colour = "blue")

#save the plot to the result directory

ggsave("../results/MyLinReg.pdf", plot = p ,
       width = 14.8, height = 10.5, units = "cm")
