/* ---------------------------------------------------------------------------- */
/* Order of Integration Analysis (I0, I1, I2) with Word Report */
/* ---------------------------------------------------------------------------- */

clear all
set more off

// Set Working Directory (Update if necessary)
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

// Load Data
use "data/integrated012.dta", clear

// Set Time Variable
tsset time

// Initialize Word Document
putdocx clear
putdocx begin

// Add Title
putdocx paragraph, halign(center)
putdocx text ("Order of Integration Analysis Report"), bold font("Arial", 16)
putdocx paragraph
putdocx text ("Variables: A, B, C, X, Y, Z"), font("Arial", 12)


/* ---------------------------------------------------------------------------- */
/* LOOP THROUGH VARIABLES */
/* ---------------------------------------------------------------------------- */

foreach var in A B C X Y Z {
    
    // Header for the Variable
    putdocx paragraph
    putdocx text ("Analysis of Variable: `var'"), bold font("Arial", 14)
    
    // --- A. Graphing ---
    
    // 1. Level
    tsline `var', title("`var' (Level)") name(g_`var'_lvl, replace) nodraw
    
    // 2. First Difference (Generate variable)
    capture drop d_`var'
    gen d_`var' = D.`var'
    tsline d_`var', title("1st Diff") name(g_`var'_d1, replace) nodraw
    
    // 3. Second Difference (Generate variable)
    capture drop d2_`var'
    gen d2_`var' = D2.`var'
    tsline d2_`var', title("2nd Diff") name(g_`var'_d2, replace) nodraw
    
    // Combine graphs side-by-side
    graph combine g_`var'_lvl g_`var'_d1 g_`var'_d2, ///
        title("Visual Inspection: `var'") rows(1) name(View_`var', replace)
    
    // Export graph to PNG and insert into Word
    graph export "graph_`var'.png", replace width(2000)
    putdocx paragraph, halign(center)
    putdocx image "graph_`var'.png", width(6)
    
    
    // --- B. Unit Root Testing Tables ---
    
    putdocx paragraph
    putdocx text ("Dickey-Fuller Test Results (`var')"), bold
    
    // Create a 4x3 Table: Header + 3 Rows for Level, Diff1, Diff2
    putdocx table tbl_`var' = (4, 3), border(all, nil) width(80%) halign(center)
    
    // Set Header Row
    putdocx table tbl_`var'(1,1) = ("Transformation"), bold border(bottom)
    putdocx table tbl_`var'(1,2) = ("Test Statistic (Zt)"), bold border(bottom) halign(center)
    putdocx table tbl_`var'(1,3) = ("MacKinnon P-Value"), bold border(bottom) halign(center)
    
    // -- Test 1: Level (I(0) Check) --
    quietly dfuller `var'
    putdocx table tbl_`var'(2,1) = ("Level")
    putdocx table tbl_`var'(2,2) = (r(Zt))
    putdocx table tbl_`var'(2,3) = (r(p))
    
    // -- Test 2: 1st Diff (I(1) Check) --
    quietly dfuller d_`var'
    putdocx table tbl_`var'(3,1) = ("1st Difference")
    putdocx table tbl_`var'(3,2) = (r(Zt))
    putdocx table tbl_`var'(3,3) = (r(p))
    
    // -- Test 3: 2nd Diff (I(2) Check) --
    quietly dfuller d2_`var'
    putdocx table tbl_`var'(4,1) = ("2nd Difference")
    putdocx table tbl_`var'(4,2) = (r(Zt))
    putdocx table tbl_`var'(4,3) = (r(p))
    
    // Formatting Numbers
    putdocx table tbl_`var'(2,2), nformat(%9.4f) halign(center)
    putdocx table tbl_`var'(2,3), nformat(%9.4f) halign(center)
    putdocx table tbl_`var'(3,2), nformat(%9.4f) halign(center)
    putdocx table tbl_`var'(3,3), nformat(%9.4f) halign(center)
    putdocx table tbl_`var'(4,2), nformat(%9.4f) halign(center)
    putdocx table tbl_`var'(4,3), nformat(%9.4f) halign(center)
    
    // Add decision rule note
    putdocx paragraph
    putdocx text ("Note: P < 0.05 indicates stationarity. Stationarity at Level = I(0); at 1st Diff = I(1); at 2nd Diff = I(2)."), italic font("Arial", 9)
    
    putdocx pagebreak
}

/* ---------------------------------------------------------------------------- */
/* SAVE DOCUMENT */
/* ---------------------------------------------------------------------------- */

putdocx save "Integrated_Series_Report.docx", replace
