cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"


*2.5 #2

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/MAexamples.dta", clear

tsset time

arima Z, ma(1/3) nocons nolog

*all the lags are statistically significant, all betas are what they are supposed to be. 

 *3.2.2 #1
 
 
 use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/ARexamples.dta", clear

 
* Resgression approach PACFs
 
reg Z L.Z // reg1 
*want to store coefficient for L.Z

reg Z L.Z L2.Z // reg2
*want to store coefficient for L2.Z

reg Z L.Z L2.Z L3.Z // reg3

*want to store coefficient for L3.Z

reg Z L.Z L2.Z L3.Z L4.Z // reg4

*want to store coefficient for L4.Z

reg Z L.Z L2.Z L3.Z L4.Z L5.Z // reg5

*want to store coefficient for L5.Z

// want to make a table for stored coefficients from five regressions


*Corrgram PACF 

corrgram Z, lags(5)

*The answers are the same regardless of the approach. 




 *3.2.2 #2

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/MAexamples.dta", clear

// PART 1 Z
 
* Resgression approach PACFs
 
reg Z L.Z // reg1 
*want to store coefficient for L.Z

reg Z L.Z L2.Z // reg2
*want to store coefficient for L2.Z

reg Z L.Z L2.Z L3.Z // reg3

*want to store coefficient for L3.Z

reg Z L.Z L2.Z L3.Z L4.Z // reg4

*want to store coefficient for L4.Z

reg Z L.Z L2.Z L3.Z L4.Z L5.Z // reg5

*want to store coefficient for L5.Z


// want to make a table for stored coefficients from five regressions



*Corrgram PACF 
 
corrgram Z, lags(5)

*The answers are the same regardless of the approach. 



// PART 2 X
 
* Resgression approach PACFs
 
reg X L.X // reg1 
*want to store coefficient for L.X

reg X L.X L2.X // reg2
*want to store coefficient for L2.X

reg X L.X L2.X L3.X // reg3

*want to store coefficient for L3.X

reg X L.X L2.X L3.X L4.X // reg4

*want to store coefficient for L4.X

reg X L.X L2.X L3.X L4.X L5.X // reg5

*want to store coefficient for L5.X

// want to make a table for stored coefficients from five regressions



*Corrgram PACF 
 
corrgram X, lags(5)

*The answers are the same regardless of the approach. 




// PART 3 Y 
 
* Resgression approach PACFs
 
reg Y L.Y // reg1 
*want to store coefficient for L.Y

reg Y L.Y L2.Y // reg2
*want to store coefficient for L2.Y

reg Y L.Y L2.Y L3.Y // reg3

*want to store coefficient for L3.Y

reg Y L.Y L2.Y L3.Y L4.Y // reg4

*want to store coefficient for L4.Y

reg Y L.Y L2.Y L3.Y L4.Y L5.Y // reg5

*want to store coefficient for L5.Y

// want to make a table for stored coefficients from five regressions



*Corrgram PACF 
 
corrgram Y, lags(5)

*The answers are the same regardless of the approach. 




// 3.3 #1 

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/ARMAexercises.dta", clear


ac X1, lags(20)
pac X1 , lags(20)

ac X2, lags(20)
pac X2 , lags(20)


ac X3, lags(20)
pac X3 , lags(20)
 

ac X4, lags(20)
pac X4, lags(20)




// 3.3 #2 

arima X1, ma(1) nolog

arima X2, ar(1) nolog

arima X3, ma(1) nolog

arima X4, ar(1) nolog




// 3.3 #3 

freduse A191RP1Q027SBEA, clear 

gen time = _n 

tsset time

keep if time <= 282

gen DelY = A191RP1Q027SBEA


ac DelY, lags(20)

pac DelY, lags(20)

arima DelY, ma(1)



// 3.4 #2 AIC 

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/ARMAexercises.dta", clear



// X1 ar and ma models!!! ICs
quietly arima X1, ar(1/4) nocons

estat ic 


quietly arima X1, ma(1/4) nocons

estat ic 

quietly arima X1, ar(1/3) nocons

estat ic 


quietly arima X1, ma(1/3) nocons

estat ic 

quietly arima X1, ar(1/2) nocons

estat ic 


quietly arima X1, ma(1/2) nocons

estat ic 

quietly arima X1, ar(1) nocons

estat ic 


quietly arima X1, ma(1) nocons

estat ic 





// X2 ar and ma models!!! ICs
quietly arima X2, ar(1/4) nocons

estat ic 


quietly arima X2, ma(1/4) nocons

estat ic 

quietly arima X2, ar(1/3) nocons

estat ic 


quietly arima X2, ma(1/3) nocons

estat ic 

quietly arima X2, ar(1/2) nocons

estat ic 


quietly arima X2, ma(1/2) nocons

estat ic 

quietly arima X2, ar(1) nocons

estat ic 


quietly arima X2, ma(1) nocons

estat ic 





// X3 ar and ma models!!! ICs
quietly arima X3, ar(1/4) nocons

estat ic 


quietly arima X3, ma(1/4) nocons

estat ic 

quietly arima X3, ar(1/3) nocons

estat ic 


quietly arima X3, ma(1/3) nocons

estat ic 

quietly arima X3, ar(1/2) nocons

estat ic 


quietly arima X3, ma(1/2) nocons

estat ic 

quietly arima X3, ar(1) nocons

estat ic 


quietly arima X3, ma(1) nocons

estat ic 





// X4 ar and ma models!!! ICs
quietly arima X4, ar(1/4) nocons

estat ic 


quietly arima X4, ma(1/4) nocons

estat ic 

quietly arima X4, ar(1/3) nocons

estat ic 


quietly arima X4, ma(1/3) nocons

estat ic 

quietly arima X4, ar(1/2) nocons

estat ic 


quietly arima X4, ma(1/2) nocons

estat ic 

quietly arima X4, ar(1) nocons

estat ic 


quietly arima X4, ma(1) nocons

estat ic 







