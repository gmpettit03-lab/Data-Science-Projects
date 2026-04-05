/* ------------------------------------------------------------------------- */
/* KPSS Unit Root Test (Replicating Kwiatkowski et al. 1992) */
/* ------------------------------------------------------------------------- */
clear all
set more off

// 1. Load Data
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/NelsonPlosserData.dta", clear
tsset year

// Ensure kpss is installed
capture which kpss
if _rc != 0 {
    display as error "Installing kpss package..."
    ssc install kpss
}

// 2. Initialize Word Report
putdocx clear
putdocx begin

putdocx paragraph, halign(center)
putdocx text ("KPSS Stationarity Test Results (Nelson-Plosser Data)"), bold font("Arial", 16)
putdocx paragraph
putdocx text ("Null Hypothesis: Series is Stationary. (Rejection implies Unit Root)."), italic font("Arial", 11)

// Define Variable List
local vars "rgnp gnp pcrgnp ip emp un prgnp cpi wg rwg m vel bnd sp500 lrgnp lgnp lpcrgnp lip lemp lun lprgnp lcpi lwg lrwg lm lvel lsp500"

// Count variables for table rows
local n_vars : word count `vars'
local n_rows = `n_vars' + 2 // Header + vars


/* ========================================================================= */
/* PART 1: Fixed Lag Analysis (Maxlag = 8) */
/* Replicating Tables 5a and 5b from KPSS (1992) */
/* ========================================================================= */

putdocx paragraph
putdocx text ("Part 1: Fixed Lag Length (maxlag=8)"), bold font("Arial", 14)

// Create Table 1
putdocx table t1 = (`n_rows', 5), width(100%) border(all, nil)
putdocx table t1(1,1) = ("Variable"), bold border(bottom)
putdocx table t1(1,2) = ("No Trend (Level)"), bold border(bottom) halign(center)
putdocx table t1(1,3) = ("Conclusion (5%)"), bold border(bottom) halign(center)
putdocx table t1(1,4) = ("With Trend"), bold border(bottom) halign(center)
putdocx table t1(1,5) = ("Conclusion (5%)"), bold border(bottom) halign(center)

local row = 2

foreach x of local vars {
    capture confirm variable `x'
    if _rc == 0 {
        putdocx table t1(`row', 1) = ("`x'")
        
        // --- A. No Trend (notrend option) ---
        quietly kpss `x', notrend maxlag(8)
        local stat_lvl = r(kpss0)
        local crit_lvl = r(kpss5)
        
        // Logic: Reject H0 (Stationary) if Stat > Crit
        if `stat_lvl' > `crit_lvl' {
            local conc_lvl "Unit Root"
        }
        else {
            local conc_lvl "Stationary"
        }
        
        putdocx table t1(`row', 2) = (`stat_lvl')
        putdocx table t1(`row', 3) = ("`conc_lvl'")
        
        // --- B. With Trend (default) ---
        quietly kpss `x', maxlag(8)
        local stat_tr = r(kpss0)
        local crit_tr = r(kpss5)
        
        if `stat_tr' > `crit_tr' {
            local conc_tr "Unit Root"
        }
        else {
            local conc_tr "Trend Stat."
        }
        
        putdocx table t1(`row', 4) = (`stat_tr')
        putdocx table t1(`row', 5) = ("`conc_tr'")
        
        // Formatting
        putdocx table t1(`row', 2), nformat(%9.3f) halign(center)
        putdocx table t1(`row', 4), nformat(%9.3f) halign(center)
        
        local row = `row' + 1
    }
}
putdocx pagebreak


/* ========================================================================= */
/* PART 2: Auto Lag Selection + Quadratic Spectral Kernel */
/* Options: auto, qs */
/* ========================================================================= */

putdocx paragraph
putdocx text ("Part 2: Automatic Bandwidth (Auto) + Quadratic Kernel (QS)"), bold font("Arial", 14)

// Create Table 2
putdocx table t2 = (`n_rows', 5), width(100%) border(all, nil)
putdocx table t2(1,1) = ("Variable"), bold border(bottom)
putdocx table t2(1,2) = ("No Trend (Level)"), bold border(bottom) halign(center)
putdocx table t2(1,3) = ("Conclusion (5%)"), bold border(bottom) halign(center)
putdocx table t2(1,4) = ("With Trend"), bold border(bottom) halign(center)
putdocx table t2(1,5) = ("Conclusion (5%)"), bold border(bottom) halign(center)

local row = 2

foreach x of local vars {
    capture confirm variable `x'
    if _rc == 0 {
        putdocx table t2(`row', 1) = ("`x'")
        
        // --- A. No Trend (notrend + auto + qs) ---
        quietly kpss `x', notrend auto qs
        local stat_lvl = r(kpss0)
        local crit_lvl = r(kpss5)
        
        if `stat_lvl' > `crit_lvl' {
            local conc_lvl "Unit Root"
        }
        else {
            local conc_lvl "Stationary"
        }
        
        putdocx table t2(`row', 2) = (`stat_lvl')
        putdocx table t2(`row', 3) = ("`conc_lvl'")
        
        // --- B. With Trend (auto + qs) ---
        quietly kpss `x', auto qs
        local stat_tr = r(kpss0)
        local crit_tr = r(kpss5)
        
        if `stat_tr' > `crit_tr' {
            local conc_tr "Unit Root"
        }
        else {
            local conc_tr "Trend Stat."
        }
        
        putdocx table t2(`row', 4) = (`stat_tr')
        putdocx table t2(`row', 5) = ("`conc_tr'")
        
        // Formatting
        putdocx table t2(`row', 2), nformat(%9.3f) halign(center)
        putdocx table t2(`row', 4), nformat(%9.3f) halign(center)
        
        local row = `row' + 1
    }
}

// 3. Save Document
putdocx save "KPSS_NelsonPlosser.docx", replace
