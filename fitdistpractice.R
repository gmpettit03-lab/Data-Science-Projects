FIT<-dlnorm(x, meanlog = 3, sdlog=1.4)
#Mode log normal
exp(3-1.4)


library(regclass)
data(EX6.WINE)

hist(EX6.WINE$residual.sugar)

FIT <- fitdist(EX6.WINE$residual.sugar, "weibull" )
summary(FIT)
qqcomp(FIT)


prequiz <- c(0.6,0.91,0.85,0.65,0.73,0.78,0.73,0.65,0.99,0.74,0.92,0.4,0.96,0.87,0.41)

dcustom<-function(x, a){(a+1)*x^a}

FIT<-fitdist(prequiz,"custom",start=list(a=3))
summary(FIT)
