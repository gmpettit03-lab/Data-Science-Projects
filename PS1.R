library(readr)
library(fitdistrplus)
loanmain <- read_csv("loanmain.csv")
?matrix


X<-c(2,0,1,4,3,2,0,9,1)
A<-matrix(data = X, nrow = 3, ncol = 3, byrow = TRUE,dimnames = NULL)
Y<-c(0,0,1,1,1,0)
B<-matrix(data = Y, nrow = 2, ncol = 3, byrow = TRUE,dimnames = NULL)
Z<-c(4,9,0,7,4,8)
C<-matrix(data = Z, nrow = 2, ncol = 3, byrow = TRUE,dimnames = NULL)
print(A)
print(B)
print(C)

??transpose
AT<-t(A)
print(AT)
BT<-t(B)
print(BT)

ABT<-A %*% BT
BAT<- B %*% AT
print(BAT)
ABTT<-t(ABT)

print(ABTT)

ZERO<-BAT-ABTT
print(ZERO)


ABTC<-ABT %*% C
print(ABTC)
t(ABTC)

# Compute AB'C
expr1 <- A %*% t(B) %*% C

# Cyclic permutation: B'CA
expr2 <- t(B) %*% C %*% A

# Another cyclic permutation: CAB'
expr3 <- C %*% A %*% t(B)

# Compute traces
tr1 <- sum(diag(expr1))
tr2 <- sum(diag(expr2))
tr3 <- sum(diag(expr3))

stopifnot(all.equal(tr1, tr2))
stopifnot(all.equal(tr1, tr3))

cat("Assertion passed: tr(AB'C) = tr(B'CA) = tr(CAB')\n")

A_inv= solve(A)
print(A_inv)

AIA<-A %*% A_inv

I<-diag(3)
print(I)
AIA-I


DATA<- as.numeric(na.omit(loanmain$lnpart5revenue))
SD<-sd(DATA)
SD
MU<-mean(DATA)
MU

TOTAL<-sum(DATA)
n<-length(DATA)

Mean=TOTAL/n
Mean
Mean-MU #This is basically 0.

StandardDEV<-sqrt(mean((DATA - mean(DATA))^2))
StandardDEV
SD-StandardDEV # this is also basically 0

