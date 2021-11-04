#Annotating plots

#Author: Chalita Chomkatekaew (chalita.chomkatekaew20@ic.ac.uk)
#version: 0.0.1

#Import package(s) required for this script

require(ggplot2)

#load the data
rm(list = ls())
a <- read.table("../data/Results.txt", header = TRUE)

head(a)

a$ymin <- rep(0, dim(a)[1]) #append a column called ymin with zeros

# Print the first linearange

p <- ggplot(a)

p <- p + geom_linerange(data = a, aes( x = x,
                                       ymin = ymin,
                                       ymax = y1,
                                       size = (0.5)
                                       ),
                        colour = "#E69F00",
                        alpha = 1/2, show.legend = FALSE)

# Print the second linerange

p <- p + geom_linerange(data = a, aes(x = x,
                                      ymin = ymin,
                                      ymax = y2,
                                      size = (0.5)
                                      ),
                        colour = "#56B4E9",
                        alpha = 1/2, show.legend = FALSE)
# Print the third linearage

p <- p + geom_linerange(data = a, aes(x = x,
                                      ymin = ymin,
                                      ymax = y3,
                                      size = (0.5)
                                      ),
                        colour = "#D55E00",
                        alpha = 1/2, show.legend = FALSE)

# Annotate the plot with labels

p <- p + geom_text(data = a, aes(x = x,
                                 y = -500,
                                 label = Label))

# now set the axis labels, remove the legend, and prepare for bw printing

p <- p + scale_x_continuous("My x axis",
                            breaks = seq(3, 5, by = 0.05)) +
  scale_y_continuous("My y axis") +
  theme_bw() +
  theme(legend.position = "none")

# Save the plot to the result directory

ggsave("../results/MyBars.pdf", plot = p ,
       width = 20, height = 14.5, units = "cm")
