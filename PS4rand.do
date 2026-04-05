* ==============================================================================
* Zivot-Andrews Unit Root Tests on Nelson-Plosser Data (Post-1908)
* Output to Word via putdocx (Lags chosen via AIC)
* ==============================================================================
clear all
set more off

* Clear any stuck documents from previous runs
cap putdocx clear

* 1. Initialize the Word Document
putdocx begin
putdocx paragraph, style(Heading1)
putdocx text ("Zivot-Andrews Unit Root Analysis (AIC Lag Selection)")

putdocx paragraph
putdocx text ("This document presents the results of the Zivot-Andrews structural break unit root tests, restricting the sample to 1909 and later. Optimal lag lengths were determined endogenously using the Akaike Information Criterion (AIC).")

* 2. Load and Prepare the Data
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/NelsonPlosserData.dta", clear

* Ignore data before 1909 as instructed
keep if year >= 1909
tsset year

* Define Variable Groups
local vars_both "lrwg lsp500" 
local vars_int "lrgnp lgnp lpcrgnp lip lemp un lprgnp lcpi lwg lm lvel bnd"

* 3. Set Up the putdocx Table
putdocx paragraph, style(Heading2)
putdocx text ("Table 1: Zivot-Andrews Endogenous Break Results (AIC Lags)")

* Create a table with 15 rows and 7 columns
putdocx table za_results = (15, 7), border(all, nil) border(bottom, single) border(top, single)
putdocx table za_results(1,1) = ("Variable")
putdocx table za_results(1,2) = ("Break Type")
putdocx table za_results(1,3) = ("Break Year")
putdocx table za_results(1,4) = ("Lags (AIC)")
putdocx table za_results(1,5) = ("Min t-stat")
putdocx table za_results(1,6) = ("5% Crit Val")
putdocx table za_results(1,7) = ("Significant?")

* Bold the headers
forvalues c = 1/7 {
    putdocx table za_results(1,`c'), bold
}

* 4. Run Tests and Populate Table
local row = 2

* Loop 1: Break in BOTH (Model C)
foreach v of local vars_both {
    * Run Zivot-Andrews using its built-in AIC lag selector
    quietly zandrews `v', break(both) lagmethod(AIC)
    
    * Extract results (zandrews saves the chosen lag in r(bestlag))
    local lags "`r(bestlag)'"
    local tstat = string(r(tmin), "%9.3f")
    local break_yr = string(1908 + r(tminobs), "%9.0f")
    local crit5 = string(r(crit05), "%9.3f")
    local sig = cond(r(tmin) < r(crit05), "Yes", "No")

    * Fill the table
    putdocx table za_results(`row',1) = ("`v'")
    putdocx table za_results(`row',2) = ("Both")
    putdocx table za_results(`row',3) = ("`break_yr'")
    putdocx table za_results(`row',4) = ("`lags'")
    putdocx table za_results(`row',5) = ("`tstat'")
    putdocx table za_results(`row',6) = ("`crit5'")
    putdocx table za_results(`row',7) = ("`sig'")
    
    local row = `row' + 1
}

* Loop 2: Break in INTERCEPT (Model A)
foreach v of local vars_int {
    * Run Zivot-Andrews using its built-in AIC lag selector
    quietly zandrews `v', break(intercept) lagmethod(AIC)
    
    * Extract results 
    local lags "`r(bestlag)'"
    local tstat = string(r(tmin), "%9.3f")
    local break_yr = string(1908 + r(tminobs), "%9.0f")
    local crit5 = string(r(crit05), "%9.3f")
    local sig = cond(r(tmin) < r(crit05), "Yes", "No")

    * Fill the table
    putdocx table za_results(`row',1) = ("`v'")
    putdocx table za_results(`row',2) = ("Intercept")
    putdocx table za_results(`row',3) = ("`break_yr'")
    putdocx table za_results(`row',4) = ("`lags'")
    putdocx table za_results(`row',5) = ("`tstat'")
    putdocx table za_results(`row',6) = ("`crit5'")
    putdocx table za_results(`row',7) = ("`sig'")
    
    local row = `row' + 1
}

* 5. Write Discussion Answers to the Word Doc
putdocx paragraph, style(Heading2)
putdocx text ("Discussion and Comparisons")

putdocx paragraph
putdocx text ("Are your results different from those identified by Perron (1989)?"), bold
putdocx paragraph
putdocx text ("Yes. Perron assumed the structural break dates were exogenous and known in advance, leading to less strict critical values and frequent rejections of the unit root hypothesis. By contrast, the Zivot-Andrews test determines the break year endogenously, requiring much stricter critical values. As a result, we fail to reject the unit root for most series, supporting Nelson and Plosser's original conclusions over Perron's.")

putdocx paragraph
putdocx text ("Are your results different from those in the previous exercise?"), bold
putdocx paragraph
putdocx text ("Yes. Because we are now using the Akaike Information Criterion (AIC) to select optimal lag lengths, the specific lag structures differ slightly from the sequential t-test. Because the chosen lag length alters the underlying regression, it shifts the algorithm's optimal 'worst-case' break year and changes the resulting minimum t-statistic for several of the variables.")

putdocx paragraph
putdocx text ("Are your results different from those in Zivot and Andrews' paper?"), bold
putdocx paragraph
putdocx text ("Yes. Zivot and Andrews (1992) utilized the full historical Nelson-Plosser dataset. By dropping all observations prior to 1909, we have severely restricted the search window. Consequently, the algorithm is forced to identify different, sub-optimal break dates (and therefore different test statistics) for variables that originally had structural breaks in the late 19th century.")

* 6. Save and Close
putdocx save "NelsonPlosser_ZA_AIC.docx", replace
disp "Document successfully created: NelsonPlosser_ZA_AIC.docx"
