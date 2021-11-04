##Example of if condition loop

a <- TRUE
if (a == TRUE) {
    print("a is TRUE")
    } else {
    print("a is FALSE")
}

z <- runif(1) ## Generate a uniformly distributed random number
if (z <= 0.5) {
    print("Less than a half")
    }

## Examples of for loops
for (i in 1:10) { #for loop for number sequence
    j <- i * i
    print(paste(i, "squared is", j ))
}

for(species in c('Heliodoxa rubinoides', #for loop for strings
                 'Boissonneaua jardini',
                 'Sula nebouxii')) {
    print(paste('This species is', species))
}

v1 <- c("a", "bc", "def")
for (i in v1){ #for loop for assigned variable
    print(i)
}

##Examples of while loops

i <- 0
while (i < 10){
    i <- i + 1
    print(i^2)
}
