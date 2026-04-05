*Read Chapter 2.1 - 2.3 of Leventides


*Answer Chapter 2.3 
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/ARexamples.dta" , clear 

tsset time

*2.3.1 

* Q3 

arima X, ar(1) nocons

irf create AR1, step(100) set(name)
 
irf graph irf 

irf drop AR1

* Q4
arima Y, ar(1 2) nocons

irf create AR2, step(100) set(name)
 
irf graph irf 

irf drop AR2

*Q5 

arima Y, ar(1 2 3) nocons

irf create AR3, step(100) set(name)
 
irf graph irf 

irf drop AR3

*Q6 

arima Z, ar(1 2 3) nocons

irf create AR3, step(100) set(name)
 
irf graph irf 

irf drop AR3



*2.3.2 #1 (all parts)

* Consider the model described in Eq. (2.11). In the text, we forecasted out to periods four and five. Now, forecast out from period six through period ten. Graph these first ten observations on Xt. Does Xt appear to be mean-stationary?

arima X, ar(1/3) nocons


tsappend, add(10)

list X in 2999/L

predict Xhat

list X Xhat in 2999/L


irf create AR3, step(10) set(name)
 
irf graph irf 

irf drop AR3




*2.3.3 #2 (don't do the by hand thing. instead, forecast out ten periods instead of four in Stata)

arima Z, ar(1/3) nocons


tsappend, add(10)

list Z in 2999/L

predict Zhat

list Z Zhat in 2999/L


irf create AR3, step(10) set(name)
 
irf graph irf 

irf drop AR3









