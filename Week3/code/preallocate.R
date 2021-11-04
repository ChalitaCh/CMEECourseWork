#Comparison between the non- and pre-allocation of the vectors
NoPreallocFun <- function(x){
    a <- vector() #empty vector
    for (i in 1:x) {
        a <- c(a, i)
        print(a)
        print(object.size(a))
    }
}

print(system.time(NoPreallocFun(100)))

PreallocFun <- function(x){
    a <- rep(NA, x) # pre-allocated vector
    for (i in 1:x){
        a[i] <- i 
        print(a)
        print(object.size(a))
    }
}

print(system.time(PreallocFun(100)))
