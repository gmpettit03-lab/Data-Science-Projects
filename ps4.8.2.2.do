* ==============================================================================
* DJIA Unit Root & Structural Break Analysis (Perron 1989)
* ==============================================================================
clear all
set more off

* 1. Initialize the Word Document
putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Time Series Analysis of DJIA (1995-2015)")

putdocx paragraph
putdocx text ("This document contains the unit root analysis of the DJIA, both standard and accounting for a structural break.")

* 2. Load the Data
* Make sure this file path exactly matches your machine
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/DJIA.dta", clear

* Generate a time index and set the time-series data
gen t = _n
tsset t

* Generate the log variable
gen logdjia = log(DJIA)

* 3. Standard Dickey-Fuller Test
putdocx paragraph, style(Heading2)
putdocx text ("Standard Dickey-Fuller Test")

* Run ADF with trend
dfuller logdjia, regress trend
local df_stat = string(r(Zt), "%9.3f")
local df_pval = string(r(p), "%9.3f")

putdocx paragraph
putdocx text ("The Augmented Dickey-Fuller test with a trend yields a test statistic of `df_stat' and a p-value of `df_pval'. Typically, this means we fail to reject the null hypothesis of a unit root.")

* 4. Graph the Data
putdocx paragraph, style(Heading2)
putdocx text ("Visualizing the Data & Structural Break")

* Generate the plot
tsline logdjia, title("Log of DJIA (1995-2015)") ///
    ytitle("Log(DJIA)") xtitle("Time (t)") ///
    xline(3440, lcolor(red) lpattern(dash)) /// Adds a red dashed line at your break
    name(djia_plot, replace)

* Export the graph to a temporary image file so putdocx can grab it
graph export "djia_plot.png", as(png) replace

putdocx paragraph
putdocx image "djia_plot.png"

* 5. Perron (1989) Procedure (Model C - Crash and Trend Change)
putdocx paragraph, style(Heading2)
putdocx text ("Perron (1989) Unit Root Test with Structural Break")

* Set the break date based on the user's Stata dataset observation row
local TB = 3440 

* Generate Perron Dummy Variables
gen DU = (t > `TB')
gen DT = (t > `TB') * (t - `TB')
gen D_TB = (t == `TB' + 1)

* Generate lags and differences for the regression
gen l_logdjia = L.logdjia
gen d_logdjia = D.logdjia
gen l_d_logdjia = L.d_logdjia

* Run the Perron regression (including 1 lag of the first difference to soak up serial correlation)
regress logdjia l_logdjia t DU DT D_TB l_d_logdjia

putdocx paragraph
putdocx text ("Below is the output for the Perron Model C regression. To determine if there is a unit root, compare the t-statistic on the 'l_logdjia' variable to the critical values found in Perron (1989), Table VI.B. Note: You must calculate lambda (TB / Total Observations) to find the correct critical value.")

* Export the regression results table to the document
putdocx table reg_results = etable

* 6. Save and Close the Document
* This will save the Word doc to your current Stata working directory.
putdocx save "DJIA_UnitRoot_Analysis.docx", replace

disp "Document successfully created: DJIA_UnitRoot_Analysis.docx"
