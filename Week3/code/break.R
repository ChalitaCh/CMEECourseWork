#This script is showing how the breaking out of the loops work in R

i <- 0 #Initialise i
    while(i < Inf) {
        if (i == 10) {
            break
            } # Break out of while loop!
        else{
            cat("i equals ", i, "\n")
            i <- i + 1 #Update i
    }
}
