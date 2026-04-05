/* ------------------------------------------------------------------------- */
/* Simulation: Difference Stationary vs Trend Stationary */
/* ------------------------------------------------------------------------- */
drop _all 
clear all 
set more off

// Initialize Word Document
putdocx clear
putdocx begin

// --- User Specified Simulation Code ---
set obs 100000
set seed 1234
gen time = _n 
tsset time 
gen error = rnormal()

* generate a Difference tationary process (random walk with drift)
gen y = error in 1 
replace y = 1 + L.y  + error in 2/L

* Generate a trend stationary process 

gen x = error in 1 

replace x = 1*time + error in 2/L

quietly reg y time 
predict dty, resid 
quietly reg x time 
predict dtx, resid 
// --------------------------------------

/* ------------------------------------------------------------------------- */
/* OUTPUT SUMMARY TABLE TO WORD */
/* ------------------------------------------------------------------------- */

// Add Title
putdocx paragraph, halign(center)
putdocx text ("Simulation Summary Statistics"), bold font("Arial", 14)

// Initialize Matrix to hold statistics
// 4 variables (D.x, D.y, dtx, dty), 5 columns (N, Mean, SD, Min, Max)
matrix Results = J(4, 5, .)
matrix colnames Results = "Obs" "Mean" "Std. Dev." "Min" "Max"
matrix rownames Results = "D.x" "D.y" "dtx" "dty"

// Loop through variables to capture stats
local row = 1
foreach var in D.x D.y dtx dty {
    quietly summarize `var'
    
    matrix Results[`row', 1] = r(N)
    matrix Results[`row', 2] = r(mean)
    matrix Results[`row', 3] = r(sd)
    matrix Results[`row', 4] = r(min)
    matrix Results[`row', 5] = r(max)
    
    local row = `row' + 1
}

// Add Table from Matrix
putdocx table tbl_stats = matrix(Results), rownames colnames border(all, nil) width(90%) halign(center)

// Format the Header
putdocx table tbl_stats(1,.), bold border(bottom)

// Format the Numbers
putdocx table tbl_stats(.,2), nformat(%9.4f) halign(center)
putdocx table tbl_stats(.,3), nformat(%9.4f) halign(center)
putdocx table tbl_stats(.,4), nformat(%9.4f) halign(center)
putdocx table tbl_stats(.,5), nformat(%9.4f) halign(center)
putdocx table tbl_stats(.,1), nformat(%9.0f) halign(center)

// Save
putdocx save "Stationarity_Simulation.docx", replace
