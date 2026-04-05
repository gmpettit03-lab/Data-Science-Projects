* -----------------------------------------------------------------------------
* STATA HOMEWORK WRAPPER
* This script runs your analysis and exports tables and graphs to "Homework_Output.docx"
* -----------------------------------------------------------------------------

* Initialize the Word Document
capture putdocx clear 
putdocx begin

* Add a Title
putdocx paragraph, style(Title) 
putdocx text ("ECON 523: Chapter 2.1 - 2.3 Answers")

* -----------------------------------------------------------------------------
* BEGIN USER CODE
* -----------------------------------------------------------------------------

*Read Chapter 2.1 - 2.3 of Leventides

*Answer Chapter 2.3 
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/ARexamples.dta" , clear 

tsset time

*2.3.1 

* Q3 

putdocx paragraph, style(Heading2)
putdocx text ("Question 3")

arima X, ar(1) nocons
estimates store m_q3

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_q3)
putdocx collect
* ---------------------------------------

irf create AR1, step(100) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_q3.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_q3.png", width(5in)
* -----------------------------

irf drop AR1

* Q4
putdocx paragraph, style(Heading2)
putdocx text ("Question 4")

arima Y, ar(1 2) nocons
estimates store m_q4

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_q4)
putdocx collect
* ---------------------------------------

irf create AR2, step(100) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_q4.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_q4.png", width(5in)
* -----------------------------

irf drop AR2

*Q5 

putdocx paragraph, style(Heading2)
putdocx text ("Question 5")

arima Y, ar(1 2 3) nocons
estimates store m_q5

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_q5)
putdocx collect
* ---------------------------------------

irf create AR3, step(100) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_q5.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_q5.png", width(5in)
* -----------------------------

irf drop AR3

*Q6 

putdocx paragraph, style(Heading2)
putdocx text ("Question 6")

arima Z, ar(1 2 3) nocons
estimates store m_q6

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_q6)
putdocx collect
* ---------------------------------------

irf create AR3, step(100) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_q6.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_q6.png", width(5in)
* -----------------------------

irf drop AR3


*2.3.2 #1 (all parts)

* Consider the model described in Eq. (2.11). In the text, we forecasted out to periods four and five. Now, forecast out from period six through period ten. Graph these first ten observations on Xt. Does Xt appear to be mean-stationary?

putdocx paragraph, style(Heading2)
putdocx text ("2.3.2 #1 - Forecasting")

arima X, ar(1/3) nocons
estimates store m_fore1

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_fore1)
putdocx collect
* ---------------------------------------

tsappend, add(10)

list X in 2999/L

predict Xhat

list X Xhat in 2999/L


irf create AR3, step(10) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_forecast1.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_forecast1.png", width(5in)
* -----------------------------

irf drop AR3


*2.3.3 #2 (don't do the by hand thing. instead, forecast out ten periods instead of four in Stata)

putdocx paragraph, style(Heading2)
putdocx text ("2.3.3 #2 - Forecasting Z")

arima Z, ar(1/3) nocons
estimates store m_fore2

* --- WRAPPER: Export Regression Table ---
etable, estimates(m_fore2)
putdocx collect
* ---------------------------------------

tsappend, add(10)

list Z in 2999/L

predict Zhat

list Z Zhat in 2999/L


irf create AR3, step(10) set(name)
 
irf graph irf 

* --- WRAPPER: Export Graph ---
graph export "temp_graph_forecast2.png", replace
putdocx paragraph, halign(center)
putdocx image "temp_graph_forecast2.png", width(5in)
* -----------------------------

irf drop AR3

* -----------------------------------------------------------------------------
* END USER CODE
* -----------------------------------------------------------------------------

* Save the Word Document
putdocx save "Homework_Output.docx", replace
