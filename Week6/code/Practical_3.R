###Genomic practical 2
##Date 11/11/21

len <- c(50000)
data_N <- as.matrix(read.csv("killer_whale_North.csv", stringsAsFactors=F, header=F, colClasses=rep("numeric", len)))
dim(data_N)
data_S <- as.matrix(read.csv("killer_whale_South.csv", stringsAsFactors=F, header=F, colClasses = rep("numeric", len)))

test <- c(0,1,1,0)
test2 <- c(1,1,0,0)

test <- c()
diff_N <- 0
n = nrow(data_N)

#Making sure that we are not comparing between themselves and repeat the comparison another way arounds

for (i in c(1:(n-1))) {
  for (j in c((i+1):n)) {
    diff <- sum(abs(data_N[i,] - data_N[j,]))
    diff_N <- diff_N + diff
  }
}

diff_S <- c()
for (i in c(1:(nrow(data_S)-1))) {
  for (j in c((i+1):nrow(data_S))) {
    diff = sum(abs(data_S[i,] - data_S[j,]))
    diff_S = diff_S + diff
  }
}

pi_N <- diff_N/(n * (n-1)/2)

Ne_N_pi <- pi_N/(4 * 1e-8 * len)


#Watt_N = snp_N/sum(1/1, 1/2, 1/3, 1/4, 1/5, ..., 1/19)

sum(1/seq(1,n-1))

snp_N <- c()

for (i in 1:ncol(data_N)) {
  if (length(unique(data_N[,i])) == 2 ) {
    snp_N <- c(snp_N, i)
  }
}

Watt_N <- length(snp_N)/sum(1/(seq(1,n-1)))

Ne_N_Watt <- Watt_N/ (4 *1e-8 *len)


## 2) site frequency spectra

### North population
sfs_N <- rep(0, n-1)
### allele frequencies
derived_freqs <- apply(X=data_N, MAR=2, FUN=sum)
### the easiest (but slowest) thing to do would be to loop over all possible allele frequencies and count the occurrences
for (i in 1:length(sfs_N)) sfs_N[i] <- length(which(derived_freqs==i))

### South population
sfs_S <- rep(0, n-1)
### allele frequencies
derived_freqs <- apply(X=data_S, MAR=2, FUN=sum)
### the easiest (but slowest) thing to do would be to loop over all possible allele frequencies and count the occurrences
for (i in 1:length(sfs_S)) sfs_S[i] <- length(which(derived_freqs==i))

### plot
barplot(t(cbind(sfs_N, sfs_S)), beside=T, names.arg=seq(1,nrow(data_S)-1,1), legend=c("North", "South"))

cat("\nThe population with the greater population size has a higher proportion of singletons, as expected.")

### bonus: joint site frequency spectrum

sfs <- matrix(0, nrow=nrow(data_N)+1, ncol=nrow(data_S)+1)
for (i in 1:ncol(data_N)) {
  
  freq_N <- sum(data_N[,i])
  freq_S <- sum(data_S[,i])
  
  sfs[freq_N+1,freq_S+1] <- sfs[freq_N+1,freq_S+1] + 1
  
}
sfs[1,1] <- NA # ignore non-SNPs

image(t(sfs))
