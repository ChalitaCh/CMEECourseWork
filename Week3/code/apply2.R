SomeOperation <- function(v){ # if sum of the matrix > 0 times it with 100
    if (sum(v) > 0){ #note that sum(v) is single (scalar) value
        return( v * 100)
    }
    return(v) #otherwise return as the sum
}

M <- matrix(rnorm(100), 10, 10)
print(apply(M, 1, SomeOperation))


