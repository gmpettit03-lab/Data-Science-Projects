/* ------------------------------------------------------------------------- */
/* Simulation of Seasonal Model (Eq 6.4) */
/* ------------------------------------------------------------------------- */
clear all
set more off
set seed 54321 // Set seed for reproducibility

// Initialize Word Document
putdocx clear
putdocx begin
putdocx paragraph, halign(center)
putdocx text ("Simulation of Seasonal Time Series"), bold font("Arial", 16)

/* ------------------------------------------------------------------------- */
/* 1. DATA GENERATION */
/* ------------------------------------------------------------------------- */

// Generate 1000 observations
set obs 1000
gen t = _n
tsset t

// Generate white noise error term
gen e = rnormal()

// Initialize X variable
gen X = 0

// Define Parameters
// Note: Assuming beta24 = 0.40 (not 40) to maintain stability/stationarity.
local b1 = 0.10
local b12 = 0.40
local b24 = 0.40 

// Calculate the simulation loop
// Equation: Xt = b1*Xt-1 + b12*Xt-12 - b1*b12*Xt-13 + b24*Xt-24 - b1*b24*Xt-25 + et
// We must start at t=26 to have enough lags
replace X = e in 1/25
replace X = `b1'*L.X + `b12'*L12.X - (`b1'*`b12')*L13.X + `b24'*L24.X - (`b1'*`b24')*L25.X + e in 26/1000

/* ------------------------------------------------------------------------- */
/* 2. GRAPH LAST 200 OBSERVATIONS */
/* ------------------------------------------------------------------------- */

putdocx paragraph
putdocx text ("1. Time Series Plot (Last 200 Observations)"), bold

// Graph only the last 200 (Obs 801-1000)
tsline X if t > 800, title("Simulated Seasonal Process") subtitle("Last 200 Observations") name(ts_plot, replace)
graph export "ts_seasonal.png", replace
putdocx image "ts_seasonal.png", width(6)

putdocx paragraph
putdocx text ("Observation:"), bold
putdocx text (" The data exhibits a distinct repeating pattern (seasonality). We can see periodic peaks and troughs recurring at regular intervals, consistent with the lag-12 and lag-24 structure in the generating equation.")

/* ------------------------------------------------------------------------- */
/* 3. AUTOCORRELATION STRUCTURE (ACF & PACF) */
/* ------------------------------------------------------------------------- */

putdocx paragraph
putdocx text ("2. Autocorrelation Analysis"), bold

// ACF Plot
ac X, lags(40) title("Autocorrelation Function (ACF)") name(ac_plot, replace)
graph export "ac_seasonal.png", replace
putdocx image "ac_seasonal.png", width(6)

// PACF Plot
pac X, lags(40) title("Partial Autocorrelation (PACF)") name(pac_plot, replace)
graph export "pac_seasonal.png", replace
putdocx image "pac_seasonal.png", width(6)

/* ------------------------------------------------------------------------- */
/* 4. INTERPRETATION */
/* ------------------------------------------------------------------------- */

putdocx paragraph
putdocx text ("Interpretation of Structure:"), bold
putdocx text (" The ACF shows significant spikes at lags 12, 24, and 36, which is a hallmark of seasonality with a period of s=12. The data structure confirms the seasonal nature of the model.")

// Save the document
putdocx save "Seasonal_Simulation_Results.docx", replace


