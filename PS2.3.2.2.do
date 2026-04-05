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


