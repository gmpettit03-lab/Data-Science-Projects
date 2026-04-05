/* ------------------------------------------------------------------------- */
/* INITIALIZATION */
/* ------------------------------------------------------------------------- */
clear all
// Set working directory
cd "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523"

// Initialize Word Document (putdocx)
putdocx clear
putdocx begin

// Add Title
putdocx paragraph, halign(center)
putdocx text ("Section 2.5 #2: Variable Z Analysis"), bold font("Arial", 16)


/* ========================================================================= */
/* SECTION 2.5 #2 - Variable Z */
/* ========================================================================= */

// Load Data for Z
use "data/MAexamples.dta", clear
tsset time

// Run Model: ARIMA(0,0,3) i.e., MA(3) no constant
arima Z, ma(1/3) nocons nolog

// Output Header
putdocx paragraph
putdocx text ("Model Results: ARIMA(0,0,3)"), bold font("Arial", 14)
putdocx paragraph
putdocx text ("Table Z: Coefficients, Standard Errors, and Confidence Intervals"), bold

// Export the estimation table
// FIX: We capture the underlying Stata results matrix 'r(table)' 
// and transpose it (') so variables are rows and stats are columns.
matrix results = r(table)'

// Create the table in the Word doc using this matrix
putdocx table tbl_z = matrix(results), rownames colnames

// Clean up table formatting
putdocx table tbl_z(1,.), bold border(bottom)
// Optional: Format numbers to 4 decimal places for cleaner look
putdocx table tbl_z(.,.), nformat(%9.4f)

// Add the user's note
putdocx paragraph
putdocx text ("Note: All lags are statistically significant. All betas are what they are supposed to be.")


/* ------------------------------------------------------------------------- */
/* SAVE DOCUMENT */
/* ------------------------------------------------------------------------- */
putdocx save "Section_2_5_Z_Analysis.docx", replace
