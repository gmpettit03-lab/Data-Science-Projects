

clear 

putpdf clear 

putpdf begin 



**Install packages 


*net install st0110_1.pkg
*FRED USE does not work
*net install wbopendata.pkg
**does not work
*net from http://researchata.com/stata/203



*Problem 3

input time X
1 10
2 15
3 23
4 20
5 19
end




tsset time
*tsset X22

*First lag
gen LagX = L.X

*Second lag
gen Lag2X = L2.X 


*first difference
gen Y = D.X

*second difference
gen Z = D.Y

list

putpdf table table3 = data(time X LagX Lag2X Y Z)









*Problem 4
* using getsymbols



* Clear memory
clear

*The book's package didn't work, so gemini helped out to find what package would work, and the syntax. 



* Download IBM data from Yahoo Finance
* Start: Jan 1, 1990
* End: Dec 31, 2012
* Frequency: Daily
getsymbols IBM, yahoo frequency(d) fy(1990) fm(1) fd(1) ly(2012) lm(12) ld(31)

* View the data
list in 1/5


gen lnIBM = log(adjclose_IBM)


list in 1/5


gen DiffIBM = D.lnIBM

list in 1/5

*Note the stock market is open from monday to friday, 1,254 represent days like mondays and days after holidays which the stock market is closed because there is no difference from the day before. 


*STEP 1 local stuff, turning this into objects


summarize DiffIBM, detail
local r_mean : display %9.5f r(mean)
local r_max = r(max)
local r_min = r(min)

*DATES

summarize date if float(DiffIBM) == float(`r_max')
local IBM_Max_date : display %td r(max)


summarize date if float(DiffIBM) == float(`r_min')
local IBM_Min_date : display %td r(min)



putpdf pagebreak
putpdf table table4 = (3,2), border(all,single)
putpdf table table4(1,1) = ("IBM Mean return")
putpdf table table4(1,2) = ("`r_mean'")
putpdf table table4(2,1) = ("Max Date")
putpdf table table4(2,2) = ("`IBM_Max_date'")
putpdf table table4(3,1) = ("Min date")
putpdf table table4(3,2) = ("`IBM_Min_date'")






* This is  .0000403, which is super close to 0. 


*figuring out the max and stuff, I used gemini right here to figure out the list function, that's new to me. 
*summarize DiffIBM, detail


*22 april 1999 best

*list date if DiffIBM == r(max)

* 18 October 2000 bad!
*list date if DiffIBM == r(min)



















*Problem 5
* using getsymbols



* Clear memory
clear





* Download MSFT data from Yahoo Finance
* Start: Jan 1, 2000
* End: Dec 31, 2012
* Frequency: Daily

getsymbols MSFT, yahoo frequency(d) fy(2000) fm(1) fd(1) ly(2012) lm(12) ld(31)

* View the data
list in 1/5


gen lnMSFT= log(adjclose_MSFT)


list in 1/5


gen DiffMSFT = D.lnMSFT

list in 1/5



mean DiffMSFT


*STEP 1 local stuff, turning this into objects


summarize DiffMSFT, detail
local r_mean : display %9.5f r(mean)
local r_max = r(max)
local r_min = r(min)


summarize date if float(DiffMSFT) == float(`r_max')
local MSFT_Max_date : display %td r(max)


summarize date if float(DiffMSFT) == float(`r_min')
local MSFT_Min_date : display %td r(min)



putpdf pagebreak
putpdf table table4 = (3,2), border(all,single)
putpdf table table4(1,1) = ("MSFT Mean return")
putpdf table table4(1,2) = ("`r_mean'")
putpdf table table4(2,1) = ("Max Date")
putpdf table table4(2,2) = ("`MSFT_Max_date'")
putpdf table table4(3,1) = ("Min date")
putpdf table table4(3,2) = ("`MSFT_Min_date'")







*summarize DiffMSFT, detail


*list date if DiffMSFT == r(max)




*list date if DiffMSFT == r(min)


putpdf save PS0_ECON523_GraysonPettit.pdf, replace




