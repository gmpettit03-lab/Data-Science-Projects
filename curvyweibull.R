curve(dexp(x,20))
pexp(,20)


curve(dweibull(x, shape=2, scale=20), from= 0, to =60)

pweibull(10, shape=2, scale=20)

pweibull(30, shape=2, scale=20)-pweibull(15, shape=2, scale=20)


1-pweibull(50, shape=2, scale=20)

pnorm(11, mean=12.5, sd=3)-pnorm(10, mean=12.5, sd=3)


qnorm(.85, mean = 12.5, sd=3)

curve(dbeta(x,shape1 = 8, shape2 = 4))

pbeta(.6,shape1 = 8, shape2 = 4)-pbeta(.5,shape1 = 8, shape2 = 4)


1-plnorm(180, meanlog=4.73,sdlog=0.35)


log(180)


integrate(function(x){.05*sqrt(x)*dlnorm(x, meanlog=4.73,sdlog=0.35)}, lower = 0, upper= Inf)




