ntrials<- 10000
weekly.demand<-c()
for (trial in 1:ntrials){
  total.demand<-(sum(sample(1:3, size=7, replace= TRUE)))
  weekly.demand[trial]<-total.demand
}

length(which(weekly.demand>= 16))/ntrials
mean(weekly.demand == 17)

mean(weekly.demand <=13) 


ntrials<-10000
num.correct<- c()
for (trial in 1:ntrials){
  tags<- sample(1:20, size = 20, replace=FALSE)
  num.correct[trial]<- sum( tags == 1:20)
}

mean(num.correct)

table(num.correct)

mean(num.correct ==0 )

mean(num.correct >= 3)


install.packages("plotrix")
library(plotrix)

n<-49
plot(0: (n+1),0:(n+1), col="white", xlab="", ylab="", axes=FALSE)
colorchoice<-sample(c("red", "orange", "yellow", "green", "blue", "brown"), size = n, replace = TRUE)

z<-1
for( i in seq(1,n,length=sqrt(n))){
  for (j in seq(1,n,length=sqrt(n))){
    draw.circle(i,j,sqrt(n)/3, col=colorchoice[z])
    z<-z+1
  }
}
title(paste(n, "M and M's"))


n<-49
colorchoice<-sample(c("red", "orange", "yellow", "green", "blue", "brown"), size = n, replace = TRUE)
table(colorchoice)


length(table(colorchoice))

length(unique(colorchoice))

n<-25
ntrials<-50000
num.colors<- c()

for (trial in 1:ntrials){
  colorchoice<-sample(c("red", "orange", "yellow", "green", "blue", "brown"), size = n, replace = TRUE)
  num.colors[trial]<- length(table(colorchoice))
  
}
table(num.colors)
mean(num.colors <= 5)




ntrials<-50000
num.colors<- c()
for (trial in 1:ntrials){
  n<-sample(18:27, size=1)
  colorchoice<-sample(c("red", "orange", "yellow", "green", "blue", "brown"), size = n, replace = TRUE)
  num.colors[trial]<- length(table(colorchoice))
}
table(num.colors)
mean(num.colors <= 5)



runif(15,min=7,max=10)

ranks<- c(7,4,3,6,5,2,1)
date.mode<-ranks[1:d]
marry.mode<-ranks[-(1:d)]
best.seen<- min(date.mode)
better.ranks<-which(marry.mode < best.seen)
chosen.rank<-marry.mode[min(better.ranks)]

m<-30
d<-6
ntrials<-5000
who.i.marry<-c()

for( trial in 1:ntrials){
  ranks<- sample(1:m, size=m, replace= FALSE)
  date.mode<-ranks[1:d]
  marry.mode<-ranks[-(1:d)]
  best.seen<- min(date.mode)
  better.ranks<-which(marry.mode < best.seen)
  if(length(better.ranks)>0){
    chosen.rank<-marry.mode[min(better.ranks)]} else {
      chosen.rank<-NA
    }
  who.i.marry[trial]<-chosen.rank
  
}
length(which(who.i.marry %in% c(1,2,3)))/ntrials

length(which(is.na(who.i.marry)))/ntrials





ntrials<-10000
counter<- 0
for( trial in 1:ntrials){
  pitches<- sample(c(1,0), size = 6, replace= TRUE, prob = c(60,40))
 if (sum(pitches)>=3){ counter= counter+1
   
 }
}
counter/ntrials





household<-c()
ntrials<-100000

for (trial in 1:ntrials){

people<-sample(c(1:4), size = 1, replace = TRUE, prob = c(30,35,15,20))
items<-sample(1:3, size =people, replace = TRUE)
prices<-sample(11:20, size=sum(items), replace=TRUE, prob=seq(from=3, to=1, length= 10) )  

household[trial]<-sum(prices)
}
hist(household)
#at most $45
mean(household<=45)
#at least $50
mean(household>=50)
#between $61 and $69
mean(69>=household & household>=61)

mean(household %in% 61:69)



ntrials<-1000000
counter<- 0
for (i in ntrials){
playlist<-sample(1:200, size = 800, replace = TRUE)
if(length(unique(playlist))==200){counter<- counter +1}
}

counter/ntrials





