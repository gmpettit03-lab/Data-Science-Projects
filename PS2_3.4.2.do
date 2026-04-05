/* ------------------------------------------------------------------------- */
/* INITIALIZATION */
/* ------------------------------------------------------------------------- */
clear all
// Set working directory
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

// Load Data
use "data/ARMAexercises.dta", clear

// Initialize Word Document (putdocx)
putdocx clear
putdocx begin

// Add Title
putdocx paragraph, halign(center)
putdocx text ("ARMA Model Comparison Report"), bold font("Arial", 16)


/* ========================================================================= */
/* VARIABLE X1 */
/* ========================================================================= */

// Clear old estimates to avoid confusion
estimates clear 

// --- Run Models X1 ---
quietly arima X1, ar(1/4) nocons
estimates store AR_4
quietly arima X1, ma(1/4) nocons
estimates store MA_4
quietly arima X1, ar(1/3) nocons
estimates store AR_3
quietly arima X1, ma(1/3) nocons
estimates store MA_3
quietly arima X1, ar(1/2) nocons
estimates store AR_2
quietly arima X1, ma(1/2) nocons
estimates store MA_2
quietly arima X1, ar(1) nocons
estimates store AR_1
quietly arima X1, ma(1) nocons
estimates store MA_1

// --- Create Matrix Table X1 ---
estimates stats AR_4 MA_4 AR_3 MA_3 AR_2 MA_2 AR_1 MA_1
matrix results_X1 = r(S)

// --- Output to Word X1 ---
putdocx paragraph, halign(center)
putdocx text ("AIC/BIC Comparison Table for X1"), bold font("Arial", 14)
putdocx paragraph
putdocx text ("Table 1: X1 Model Fit Statistics"), bold

putdocx table tbl_x1 = matrix(results_X1), rownames colnames
putdocx table tbl_x1(1,.), bold border(bottom)
putdocx table tbl_x1(.,2), halign(center)
putdocx table tbl_x1(.,3), halign(center)
putdocx table tbl_x1(.,4), halign(center)
putdocx table tbl_x1(.,5), halign(center)
putdocx table tbl_x1(.,6), halign(center)
putdocx table tbl_x1(.,7), halign(center)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X2 */
/* ========================================================================= */

estimates clear 

// --- Run Models X2 ---
quietly arima X2, ar(1/4) nocons
estimates store AR_4
quietly arima X2, ma(1/4) nocons
estimates store MA_4
quietly arima X2, ar(1/3) nocons
estimates store AR_3
quietly arima X2, ma(1/3) nocons
estimates store MA_3
quietly arima X2, ar(1/2) nocons
estimates store AR_2
quietly arima X2, ma(1/2) nocons
estimates store MA_2
quietly arima X2, ar(1) nocons
estimates store AR_1
quietly arima X2, ma(1) nocons
estimates store MA_1

// --- Create Matrix Table X2 ---
estimates stats AR_4 MA_4 AR_3 MA_3 AR_2 MA_2 AR_1 MA_1
matrix results_X2 = r(S)

// --- Output to Word X2 ---
putdocx paragraph, halign(center)
putdocx text ("AIC/BIC Comparison Table for X2"), bold font("Arial", 14)
putdocx paragraph
putdocx text ("Table 2: X2 Model Fit Statistics"), bold

putdocx table tbl_x2 = matrix(results_X2), rownames colnames
putdocx table tbl_x2(1,.), bold border(bottom)
putdocx table tbl_x2(.,2), halign(center)
putdocx table tbl_x2(.,3), halign(center)
putdocx table tbl_x2(.,4), halign(center)
putdocx table tbl_x2(.,5), halign(center)
putdocx table tbl_x2(.,6), halign(center)
putdocx table tbl_x2(.,7), halign(center)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X3 */
/* ========================================================================= */

estimates clear 

// --- Run Models X3 ---
quietly arima X3, ar(1/4) nocons
estimates store AR_4
quietly arima X3, ma(1/4) nocons
estimates store MA_4
quietly arima X3, ar(1/3) nocons
estimates store AR_3
quietly arima X3, ma(1/3) nocons
estimates store MA_3
quietly arima X3, ar(1/2) nocons
estimates store AR_2
quietly arima X3, ma(1/2) nocons
estimates store MA_2
quietly arima X3, ar(1) nocons
estimates store AR_1
quietly arima X3, ma(1) nocons
estimates store MA_1

// --- Create Matrix Table X3 ---
estimates stats AR_4 MA_4 AR_3 MA_3 AR_2 MA_2 AR_1 MA_1
matrix results_X3 = r(S)

// --- Output to Word X3 ---
putdocx paragraph, halign(center)
putdocx text ("AIC/BIC Comparison Table for X3"), bold font("Arial", 14)
putdocx paragraph
putdocx text ("Table 3: X3 Model Fit Statistics"), bold

putdocx table tbl_x3 = matrix(results_X3), rownames colnames
putdocx table tbl_x3(1,.), bold border(bottom)
putdocx table tbl_x3(.,2), halign(center)
putdocx table tbl_x3(.,3), halign(center)
putdocx table tbl_x3(.,4), halign(center)
putdocx table tbl_x3(.,5), halign(center)
putdocx table tbl_x3(.,6), halign(center)
putdocx table tbl_x3(.,7), halign(center)
putdocx pagebreak


/* ========================================================================= */
/* VARIABLE X4 */
/* ========================================================================= */

estimates clear 

// --- Run Models X4 ---
quietly arima X4, ar(1/4) nocons
estimates store AR_4
quietly arima X4, ma(1/4) nocons
estimates store MA_4
quietly arima X4, ar(1/3) nocons
estimates store AR_3
quietly arima X4, ma(1/3) nocons
estimates store MA_3
quietly arima X4, ar(1/2) nocons
estimates store AR_2
quietly arima X4, ma(1/2) nocons
estimates store MA_2
quietly arima X4, ar(1) nocons
estimates store AR_1
quietly arima X4, ma(1) nocons
estimates store MA_1

// --- Create Matrix Table X4 ---
estimates stats AR_4 MA_4 AR_3 MA_3 AR_2 MA_2 AR_1 MA_1
matrix results_X4 = r(S)

// --- Output to Word X4 ---
putdocx paragraph, halign(center)
putdocx text ("AIC/BIC Comparison Table for X4"), bold font("Arial", 14)
putdocx paragraph
putdocx text ("Table 4: X4 Model Fit Statistics"), bold

putdocx table tbl_x4 = matrix(results_X4), rownames colnames
putdocx table tbl_x4(1,.), bold border(bottom)
putdocx table tbl_x4(.,2), halign(center)
putdocx table tbl_x4(.,3), halign(center)
putdocx table tbl_x4(.,4), halign(center)
putdocx table tbl_x4(.,5), halign(center)
putdocx table tbl_x4(.,6), halign(center)
putdocx table tbl_x4(.,7), halign(center)


/* ------------------------------------------------------------------------- */
/* SAVE DOCUMENT */
/* ------------------------------------------------------------------------- */
putdocx save "IC3_4_2.docx", replace
