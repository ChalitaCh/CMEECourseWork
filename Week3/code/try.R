##Catching the errors in R

doit <- function(x){
    ##Define a function to catch the error
    temp_x <- sample(x, replace = TRUE)
    if(length(unique(temp_x)) > 30 ){
        print(paste("Mean of this sample was:", as.character(mean(temp_x))))
        }
    else{
        stop("Couldn't calculate mean: too few unique values!")
        }
    }

## set the seed to ensure reproducibility
set.seed(1345) 
popn <- rnorm(50)
hist(popn) 

result <- lapply(1:15, function (i) try(doit(popn), FALSE))

class(result)
result