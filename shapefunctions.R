
shape<- function(x) {1-((x-2)*(x-7))}

recip<-integrate(shape, lower =2, upper = 7)

recip


shape<- function(x){6/((1+x)^2)}

recip<-integrate(shape, lower=1, upper= 2)
recip


integrate(shape, lower = 1.6, upper= 1.7)



.7/.3
.6/.4



# 2 25.83333

# 3 0.08547009

# 5 1.5


mu<-integrate(function(x) x*60*x^2*(1-x)^3, lower = 0, upper = 1)$value
mu

sigma<- sqrt(integrate(function(x) (x-mu)^2*60*x^2*(1-x)^3, lower = 0, upper = 1)$value)
sigma


optimize(function(x) 60*x^2*(1-x)^3, interval=c(0,1), maximum = TRUE)



integrate(function(x) 50*x^3*60*x^2*(1-x)^3, lower = 0, upper = 1)


50*mu^3


