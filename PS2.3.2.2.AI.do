/* ------------------------------------------------------------------------- */
/* INITIALIZATION */
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
putdocx text ("Partial Autocorrelation Function (PACF) Analysis"), bold font("Arial", 16)
putdocx text ("\nComparison of Regression Approach vs Corrgram"), font("Arial", 12)

/* ========================================================================= */
/* SECTION 3.2.2 #1 - Variable Z (ARexamples.dta) */
/* ========================================================================= */

use "data/ARexamples.dta", clear
tsset time

putdocx paragraph, halign(center)
putdocx text ("Section 3.2.2 #1: Variable Z (AR Data)"), bold font("Arial", 14)

// --- Step 1: Run Regressions and Extract Specific Coefficients ---

// Reg 1: Lag 1 -> Get L.Z
quietly reg Z L.Z
scalar b1 = _b[L.Z]

// Reg 2: Lag 1,2 -> Get L2.Z
quietly reg Z L.Z L2.Z
scalar b2 = _b[L2.Z]

// Reg 3: Lag 1..3 -> Get L3.Z
quietly reg Z L.Z L2.Z L3.Z
scalar b3 = _b[L3.Z]

// Reg 4: Lag 1..4 -> Get L4.Z
quietly reg Z L.Z L2.Z L3.Z L4.Z
scalar b4 = _b[L4.Z]

// Reg 5: Lag 1..5 -> Get L5.Z
quietly reg Z L.Z L2.Z L3.Z L4.Z L5.Z
scalar b5 = _b[L5.Z]

// --- Step 2: Build the Matrix ---
matrix Reg_PACF = (b1 \ b2 \ b3 \ b4 \ b5)
matrix rownames Reg_PACF = "Lag 1" "Lag 2" "Lag 3" "Lag 4" "Lag 5"
matrix colnames Reg_PACF = "Regression_Coeff"

// --- Step 3: Get Corrgram Values for Comparison ---
quietly corrgram Z, lags(5)
matrix Corr_PACF = r(PAC)
// Transpose because r(PAC) is a row vector
matrix Corr_PACF = Corr_PACF' 
matrix colnames Corr_PACF = "Corrgram_PACF"

// Combine them side-by-side
matrix Final_Z1 = Reg_PACF, Corr_PACF

// --- Step 4: Output Table ---
putdocx paragraph
putdocx text ("Table 1: PACF Coefficients (Regression vs Corrgram)"), bold
putdocx table tbl_z1 = matrix(Final_Z1), rownames colnames
putdocx table tbl_z1(1,.), bold border(bottom)
putdocx table tbl_z1(.,.), nformat(%9.4f) halign(center)

// --- Step 5: Output Visual Corrgram ---
putdocx paragraph
putdocx text ("Correlogram Plot (PAC)"), bold
pac Z, lags(5) title("PACF Plot - Z (AR)") note("")
graph export "pac_z1.png", replace
putdocx image "pac_z1.png", width(4)
putdocx pagebreak


/* ========================================================================= */
/* SECTION 3.2.2 #2 - Variable Z (MAexamples.dta) */
/* ========================================================================= */

use "data/MAexamples.dta", clear
tsset time

putdocx paragraph, halign(center)
putdocx text ("Section 3.2.2 #2: Variable Z (MA Data)"), bold font("Arial", 14)

// --- Regressions ---
quietly reg Z L.Z
scalar b1 = _b[L.Z]

quietly reg Z L.Z L2.Z
scalar b2 = _b[L2.Z]

quietly reg Z L.Z L2.Z L3.Z
scalar b3 = _b[L3.Z]

quietly reg Z L.Z L2.Z L3.Z L4.Z
scalar b4 = _b[L4.Z]

quietly reg Z L.Z L2.Z L3.Z L4.Z L5.Z
scalar b5 = _b[L5.Z]

// --- Matrix Construction ---
matrix Reg_PACF = (b1 \ b2 \ b3 \ b4 \ b5)
matrix rownames Reg_PACF = "Lag 1" "Lag 2" "Lag 3" "Lag 4" "Lag 5"
matrix colnames Reg_PACF = "Regression_Coeff"

quietly corrgram Z, lags(5)
matrix Corr_PACF = r(PAC)'
matrix colnames Corr_PACF = "Corrgram_PACF"
matrix Final_Z2 = Reg_PACF, Corr_PACF

// --- Output ---
putdocx paragraph
putdocx text ("Table 2: PACF Coefficients (Z)"), bold
putdocx table tbl_z2 = matrix(Final_Z2), rownames colnames
putdocx table tbl_z2(1,.), bold border(bottom)
putdocx table tbl_z2(.,.), nformat(%9.4f) halign(center)

putdocx paragraph
putdocx text ("Correlogram Plot (PAC)"), bold
pac Z, lags(5) title("PACF Plot - Z (MA)") note("")
graph export "pac_z2.png", replace
putdocx image "pac_z2.png", width(4)
putdocx pagebreak


/* ========================================================================= */
/* SECTION 3.2.2 #2 - Variable X */
/* ========================================================================= */

putdocx paragraph, halign(center)
putdocx text ("Section 3.2.2 #2: Variable X"), bold font("Arial", 14)

// --- Regressions ---
quietly reg X L.X
scalar b1 = _b[L.X]

quietly reg X L.X L2.X
scalar b2 = _b[L2.X]

quietly reg X L.X L2.X L3.X
scalar b3 = _b[L3.X]

quietly reg X L.X L2.X L3.X L4.X
scalar b4 = _b[L4.X]

quietly reg X L.X L2.X L3.X L4.X L5.X
scalar b5 = _b[L5.X]

// --- Matrix Construction ---
matrix Reg_PACF = (b1 \ b2 \ b3 \ b4 \ b5)
matrix rownames Reg_PACF = "Lag 1" "Lag 2" "Lag 3" "Lag 4" "Lag 5"
matrix colnames Reg_PACF = "Regression_Coeff"

quietly corrgram X, lags(5)
matrix Corr_PACF = r(PAC)'
matrix colnames Corr_PACF = "Corrgram_PACF"
matrix Final_X = Reg_PACF, Corr_PACF

// --- Output ---
putdocx paragraph
putdocx text ("Table 3: PACF Coefficients (X)"), bold
putdocx table tbl_x = matrix(Final_X), rownames colnames
putdocx table tbl_x(1,.), bold border(bottom)
putdocx table tbl_x(.,.), nformat(%9.4f) halign(center)

putdocx paragraph
putdocx text ("Correlogram Plot (PAC)"), bold
pac X, lags(5) title("PACF Plot - X") note("")
graph export "pac_x.png", replace
putdocx image "pac_x.png", width(4)
putdocx pagebreak


/* ========================================================================= */
/* SECTION 3.2.2 #2 - Variable Y */
/* ========================================================================= */

putdocx paragraph, halign(center)
putdocx text ("Section 3.2.2 #2: Variable Y"), bold font("Arial", 14)

// --- Regressions ---
quietly reg Y L.Y
scalar b1 = _b[L.Y]

quietly reg Y L.Y L2.Y
scalar b2 = _b[L2.Y]

quietly reg Y L.Y L2.Y L3.Y
scalar b3 = _b[L3.Y]

quietly reg Y L.Y L2.Y L3.Y L4.Y
scalar b4 = _b[L4.Y]

quietly reg Y L.Y L2.Y L3.Y L4.Y L5.Y
scalar b5 = _b[L5.Y]

// --- Matrix Construction ---
matrix Reg_PACF = (b1 \ b2 \ b3 \ b4 \ b5)
matrix rownames Reg_PACF = "Lag 1" "Lag 2" "Lag 3" "Lag 4" "Lag 5"
matrix colnames Reg_PACF = "Regression_Coeff"

quietly corrgram Y, lags(5)
matrix Corr_PACF = r(PAC)'
matrix colnames Corr_PACF = "Corrgram_PACF"
matrix Final_Y = Reg_PACF, Corr_PACF

// --- Output ---
putdocx paragraph
putdocx text ("Table 4: PACF Coefficients (Y)"), bold
putdocx table tbl_y = matrix(Final_Y), rownames colnames
putdocx table tbl_y(1,.), bold border(bottom)
putdocx table tbl_y(.,.), nformat(%9.4f) halign(center)

putdocx paragraph
putdocx text ("Correlogram Plot (PAC)"), bold
pac Y, lags(5) title("PACF Plot - Y") note("")
graph export "pac_y.png", replace
putdocx image "pac_y.png", width(4)


/* ------------------------------------------------------------------------- */
/* SAVE DOCUMENT */
/* ------------------------------------------------------------------------- */
putdocx save "PACF_Calculations.docx", replace
