/* ------------------------------------------------------------------------- */
/* DF-GLS Unit Root Test on Nelson-Plosser Data */
/* ------------------------------------------------------------------------- */
clear all
set more off

// 1. Load Data (Updated to Local Path)
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/NelsonPlosserData.dta", clear
tsset year

// 2. Initialize Word Report
putdocx clear
putdocx begin

putdocx paragraph, halign(center)
putdocx text ("DF-GLS Unit Root Test Results (Nelson-Plosser 1982)"), bold font("Arial", 16)
putdocx paragraph
putdocx text ("Specification: Trend included. Lag selection: Modified AIC (MAIC). Test Size: 5%."), font("Arial", 11)

// Define variable list 
local vars "rgnp gnp pcrgnp ip emp un prgnp cpi wg rwg m vel bnd sp500 lrgnp lgnp lpcrgnp lip lemp lun lprgnp lcpi lwg lrwg lm lvel lsp500"

// Count variables to pre-allocate table rows
local n_vars : word count `vars'
local n_rows = `n_vars' + 1

// 3. Create Summary Table Structure (Pre-allocated)
putdocx table results = (`n_rows', 5), width(100%) border(all, nil)
putdocx table results(1,1) = ("Variable"), bold border(bottom)
putdocx table results(1,2) = ("Opt. Lag (MAIC)"), bold border(bottom) halign(center)
putdocx table results(1,3) = ("Test Stat"), bold border(bottom) halign(center)
putdocx table results(1,4) = ("5% Crit Value"), bold border(bottom) halign(center)
putdocx table results(1,5) = ("Conclusion"), bold border(bottom)

// 4. Loop through variables
local row = 2 

foreach x of local vars {
    
    // Check if variable exists before running to avoid errors
    capture confirm variable `x'
    if _rc == 0 {
        // Run DF-GLS with a trend (default) and maxlag of 8
        quietly dfgls `x', maxlag(8)
        
        // Get the results matrix
        matrix Res = r(results)
        
        // --- Algorithm to find Lag with Minimum MAIC ---
        // Initialize with the first row
        local best_lag = Res[1, 1]
        local t_stat   = Res[1, 2]
        local crit_5   = Res[1, 4]
        local min_maic = Res[1, 6]
        
        local num_rows = rowsof(Res)
        
        // Iterate through rows 2 to N to find the absolute minimum MAIC
        forvalues i = 2/`num_rows' {
            if Res[`i', 6] < `min_maic' {
                local min_maic = Res[`i', 6]
                local best_lag = Res[`i', 1]
                local t_stat   = Res[`i', 2]
                local crit_5   = Res[`i', 4]
            }
        }
        
        // --- Determine Conclusion ---
        // Reject H0 (Unit Root) if Test Statistic < Critical Value (more negative)
        if `t_stat' < `crit_5' {
            local conclusion "Trend Stationary"
        }
        else {
            local conclusion "Random Walk (Drift)"
        }
        
        // Fill the specific row in the table
        putdocx table results(`row', 1) = ("`x'")
        putdocx table results(`row', 2) = (`best_lag')
        putdocx table results(`row', 3) = (`t_stat')
        putdocx table results(`row', 4) = (`crit_5')
        putdocx table results(`row', 5) = ("`conclusion'")
        
        // Formatting numbers
        putdocx table results(`row', 3), nformat(%9.3f) halign(center)
        putdocx table results(`row', 4), nformat(%9.3f) halign(center)
        putdocx table results(`row', 2), halign(center)
        
        // Increment row counter
        local row = `row' + 1
    }
    else {
        display as error "Variable `x' not found in dataset. Skipping."
        // Note: If skipped, that row in the table will remain empty
    }
}

// 5. Save Document
putdocx save "NelsonPlosser_DFGLS.docx", replace
