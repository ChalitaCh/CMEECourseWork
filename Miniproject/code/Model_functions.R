#Model function

#Define the parameters in the models
#N0 = initial population size
#r = maximum growth rate 
#K = carrying capacity
#t = time
#t_lag = time when lag phase ends

#Logistic regression

logistic <- function(t, rmax, K, N0){
  Nt = N0 * K * exp(rmax * t)/(K + N0 * (exp(rmax * t) - 1))
  return(Nt)
}

#Gompertz

gompertz <- function(t, rmax, K, N0, t_lag){
  Nt = (N0 + (K - N0) * exp(-exp(rmax * exp(1) * (t_lag - t)/((K - N0) * log(10)) + 1)))
  return(Nt)
}


#Quadratic model

quadratic <- function(x, a, b, c){
  y = c + a * x + b * (x^2)
  return(y)
}

#Cubic model

cubic <- function(x, a, b, c, d){
  y = d + a * x + b * (x^2) + c * (x^3)
}




