/* ------------------------------------------------------------------------- */
/* SETUP */
/* ------------------------------------------------------------------------- */
clear all
set more off
// Set working directory
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

// Initialize Word Document
putdocx clear
putdocx begin

// Title
putdocx paragraph, halign(center)
putdocx text ("Section 3.3: ARMA Identification and Estimation"), bold font("Arial", 16)

/* ========================================================================= */
/* VARIABLE X1 */
/* ========================================================================= */
use "data/ARMAexercises.dta", clear
putdocx paragraph
putdocx text ("Variable X1 Analysis"), bold font("Arial", 14)

// --- 1. Graphs (AC & PAC) ---
ac X1, lags(20) title("ACF X1")
graph export "ac_x1.png", replace
pac X1, lags(20) title("PACF X1")
graph export "pac_x1.png", replace

putdocx paragraph
putdocx text ("Figure 1: ACF and PACF for X1")

// Create 1x2 Table for Side-by-Side Images
putdocx table g1 = (1,2), border(all, nil)
putdocx table g1(1,1) = image("ac_x1.png")
putdocx table g1(1,2) = image("pac_x1.png")

// --- 2. Model Estimation (MA 1) ---
putdocx paragraph
putdocx text ("Estimation Model: MA(1)"), bold

// Run initial model WITH constant
quietly arima X1, ma(1) nolog

// Check significance of constant gracefully
matrix T = r(table)
capture scalar p_val = T["pvalue", "_cons"]

if _rc != 0 {
    // Case: _cons not found in the table
    putdocx paragraph
    putdocx text ("Note: No constant term was reported in the initial estimation.")
    // Re-run quietly just to ensure active results for table
    quietly arima X1, ma(1) nolog
}
else if p_val > 0.05 {
    // Case: Constant is insignificant -> Drop it
    putdocx paragraph
    putdocx text ("Note: The constant was insignificant (p > 0.05). Dropping constant and re-estimating.")
    arima X1, ma(1) nocons nolog
}
else {
    // Case: Constant is significant -> Keep it
    putdocx paragraph
    putdocx text ("Note: The constant is significant. Keeping constant.")
    arima X1, ma(1) nolog
}

// Save Result to Table using Matrix capture (Fix for r(198))
matrix results_t1 = r(table)'
putdocx table t1 = matrix(results_t1), rownames colnames
putdocx table t1(1,.), bold border(bottom)
putdocx table t1(.,.), nformat(%9.4f)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X2 */
/* ========================================================================= */
putdocx paragraph
putdocx text ("Variable X2 Analysis"), bold font("Arial", 14)

// --- 1. Graphs ---
ac X2, lags(20) title("ACF X2")
graph export "ac_x2.png", replace
pac X2, lags(20) title("PACF X2")
graph export "pac_x2.png", replace

putdocx paragraph
putdocx text ("Figure 2: ACF and PACF for X2")
putdocx table g2 = (1,2), border(all, nil)
putdocx table g2(1,1) = image("ac_x2.png")
putdocx table g2(1,2) = image("pac_x2.png")

// --- 2. Model Estimation (AR 1) ---
putdocx paragraph
putdocx text ("Estimation Model: AR(1)"), bold

// Run initial model
quietly arima X2, ar(1) nolog

// Check significance
matrix T = r(table)
capture scalar p_val = T["pvalue", "_cons"]

if _rc != 0 {
    putdocx paragraph
    putdocx text ("Note: No constant term was reported in the initial estimation.")
    quietly arima X2, ar(1) nolog
}
else if p_val > 0.05 {
    putdocx paragraph
    putdocx text ("Note: The constant was insignificant (p > 0.05). Dropping constant and re-estimating.")
    arima X2, ar(1) nocons nolog
}
else {
    putdocx paragraph
    putdocx text ("Note: The constant is significant. Keeping constant.")
    arima X2, ar(1) nolog
}

// Save Result to Table using Matrix capture (Fix for r(198))
matrix results_t2 = r(table)'
putdocx table t2 = matrix(results_t2), rownames colnames
putdocx table t2(1,.), bold border(bottom)
putdocx table t2(.,.), nformat(%9.4f)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X3 */
/* ========================================================================= */
putdocx paragraph
putdocx text ("Variable X3 Analysis"), bold font("Arial", 14)

// --- 1. Graphs ---
ac X3, lags(20) title("ACF X3")
graph export "ac_x3.png", replace
pac X3, lags(20) title("PACF X3")
graph export "pac_x3.png", replace

putdocx paragraph
putdocx text ("Figure 3: ACF and PACF for X3")
putdocx table g3 = (1,2), border(all, nil)
putdocx table g3(1,1) = image("ac_x3.png")
putdocx table g3(1,2) = image("pac_x3.png")

// --- 2. Model Estimation (MA 1) ---
putdocx paragraph
putdocx text ("Estimation Model: MA(1)"), bold

// Run initial model
quietly arima X3, ma(1) nolog

// Check significance
matrix T = r(table)
capture scalar p_val = T["pvalue", "_cons"]

if _rc != 0 {
    putdocx paragraph
    putdocx text ("Note: No constant term was reported in the initial estimation.")
    quietly arima X3, ma(1) nolog
}
else if p_val > 0.05 {
    putdocx paragraph
    putdocx text ("Note: The constant was insignificant (p > 0.05). Dropping constant and re-estimating.")
    arima X3, ma(1) nocons nolog
}
else {
    putdocx paragraph
    putdocx text ("Note: The constant is significant. Keeping constant.")
    arima X3, ma(1) nolog
}

// Save Result to Table using Matrix capture (Fix for r(198))
matrix results_t3 = r(table)'
putdocx table t3 = matrix(results_t3), rownames colnames
putdocx table t3(1,.), bold border(bottom)
putdocx table t3(.,.), nformat(%9.4f)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X4 */
/* ========================================================================= */
putdocx paragraph
putdocx text ("Variable X4 Analysis"), bold font("Arial", 14)

// --- 1. Graphs ---
ac X4, lags(20) title("ACF X4")
graph export "ac_x4.png", replace
pac X4, lags(20) title("PACF X4")
graph export "pac_x4.png", replace

putdocx paragraph
putdocx text ("Figure 4: ACF and PACF for X4")
putdocx table g4 = (1,2), border(all, nil)
putdocx table g4(1,1) = image("ac_x4.png")
putdocx table g4(1,2) = image("pac_x4.png")

// --- 2. Model Estimation (AR 1) ---
putdocx paragraph
putdocx text ("Estimation Model: AR(1)"), bold

// Run initial model
quietly arima X4, ar(1) nolog

// Check significance
matrix T = r(table)
capture scalar p_val = T["pvalue", "_cons"]

if _rc != 0 {
    putdocx paragraph
    putdocx text ("Note: No constant term was reported in the initial estimation.")
    quietly arima X4, ar(1) nolog
}
else if p_val > 0.05 {
    putdocx paragraph
    putdocx text ("Note: The constant was insignificant (p > 0.05). Dropping constant and re-estimating.")
    arima X4, ar(1) nocons nolog
}
else {
    putdocx paragraph
    putdocx text ("Note: The constant is significant. Keeping constant.")
    arima X4, ar(1) nolog
}

// Save Result to Table using Matrix capture (Fix for r(198))
matrix results_t4 = r(table)'
putdocx table t4 = matrix(results_t4), rownames colnames
putdocx table t4(1,.), bold border(bottom)
putdocx table t4(.,.), nformat(%9.4f)


/* ------------------------------------------------------------------------- */
/* SAVE */
/* ------------------------------------------------------------------------- */
putdocx save "ARMA_Questions_3_3.docx", replace
