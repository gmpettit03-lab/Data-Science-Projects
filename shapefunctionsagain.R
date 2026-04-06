x <- 1:10
shape <- x*(12-x) 
barplot(shape,names.arg=x)

(shape/sum(shape))[5]


x <- 2:60; p <- c(.75,.5^(x[-1]))
sum(p)  #valid set of probabilities!

sum(p[which(x<=7) ])
#can add & symbol in which condition



x<- 1:15
shape<- x*exp(-0.2*x)
barplot(shape,names.arg = x)
shape
p<-shape/sum(shape)
p
sum(p)
barplot(p,names.arg = x)

sum(p[which(x<= 3)])

sum(p[which(x >=4 & x <= 13)])

sum(p[which(x>= 101)])



#what if no limit on items

x<-1:1000000
shape<- x*exp(-0.2*x)
barplot(shape,names.arg = x)
shape
p<-shape* (1/24.9168)
p
sum(p)
barplot(p,names.arg = x)
