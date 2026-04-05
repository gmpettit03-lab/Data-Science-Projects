/* ------------------------------------------------------------------------- */
/* Stock Market Unit Root Analysis (Part 2 Only) */
/* Methodology: Augmented Dickey-Fuller (ADF) Test */
/* ------------------------------------------------------------------------- */
clear all
set more off

// 1. Initialize Word Report
putdocx clear
putdocx begin

putdocx paragraph, halign(center)
putdocx text ("Stock Market Unit Root Analysis (2013-2017)"), bold font("Arial", 16)
putdocx paragraph
putdocx text ("Methodology: Augmented Dickey-Fuller (ADF) Test with Trend."), italic font("Arial", 11)
putdocx paragraph
putdocx text ("Null Hypothesis: Unit Root (Random Walk). Alternative: Trend Stationary."), italic font("Arial", 10)

/* ========================================================================= */
/* PART 2: Stock Market Indexes (2013-2017) */
/* Data: Daily NASDAQ, CAC-40, DAX */
/* ========================================================================= */

putdocx paragraph
putdocx text ("Major Stock Market Indexes (2013-2017)"), bold font("Arial", 14)

// 2. Load Data (Specific Local Path)
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/Index.dta", clear

// 3. Rename Specific Variables
// Mapping your provided names to the analysis names
capture rename adjclose__IXIC nasdaq
capture rename adjclose__FCHI cac40
capture rename adjclose__GDAXI dax

// --- DEBUG: Verify Renaming ---
display "---------------------------------------------------"
display "VARIABLES IN MEMORY:"
describe
display "---------------------------------------------------"

// 4. Setup Time Series
// We generate a sequence 't' to handle weekends/holidays (gaps) cleanly
capture drop t
gen t = _n
tsset t

// Define Stock Vars
local stock_vars "nasdaq cac40 dax"

// 5. Create Table Header
putdocx table t2 = (4, 5), width(100%) border(all, nil)
putdocx table t2(1,1) = ("Index"), bold border(bottom)
putdocx table t2(1,2) = ("Test Statistic"), bold border(bottom) halign(center)
putdocx table t2(1,3) = ("1% Crit Value"), bold border(bottom) halign(center)
putdocx table t2(1,4) = ("5% Crit Value"), bold border(bottom) halign(center)
putdocx table t2(1,5) = ("Conclusion (5%)"), bold border(bottom) halign(center)

local row = 2

// 6. Loop through variables and run ADF Test
foreach x of local stock_vars {
    // Check if variable exists before testing
    capture confirm variable `x'
    if _rc == 0 {
        // Run ADF Test with Trend and 5 lags (standard for daily data in this context)
        quietly dfuller `x', trend lags(5)
        
        local stat = r(Zt)
        local crit1 = r(cv_1)
        local crit5 = r(cv_5)
        
        if `stat' < `crit5' {
            local conc "Trend Stationary"
        }
        else {
            local conc "Unit Root"
        }
        
        putdocx table t2(`row', 1) = ("`x'")
        putdocx table t2(`row', 2) = (`stat')
        putdocx table t2(`row', 3) = (`crit1')
        putdocx table t2(`row', 4) = (`crit5')
        putdocx table t2(`row', 5) = ("`conc'")
        
        putdocx table t2(`row', 2), nformat(%9.3f) halign(center)
        putdocx table t2(`row', 3), nformat(%9.3f) halign(center)
        putdocx table t2(`row', 4), nformat(%9.3f) halign(center)
        
        local row = `row' + 1
    }
    else {
        // Report missing variable in Stata console
        display as error "Variable `x' not found. Check if the input names matched exactly."
        putdocx table t2(`row', 1) = ("`x' (Missing)")
        local row = `row' + 1
    }
}

// 7. Save Document
putdocx save "Stock_Market_Analysis.docx", replace
