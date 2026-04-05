clear all
set more off

* 1. Load Data
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/arch-F.dta", clear
gen y = F

* Ensure time series is set
tsset time

* ---------------------------------------------------------
* Step 1: Mean Equation & Optimal Lag Selection
* ---------------------------------------------------------
local maxlag = 31
scalar min_bic = .
scalar opt_lag = .

forvalues i = 1/`maxlag' {
    quietly {
        if `i'==0 regress y
        else       regress y L(1/`i').y
    }
    scalar bic_i = -2*e(ll) + e(rank)*ln(e(N))

    if missing(min_bic) | (bic_i < min_bic) {
        scalar min_bic = bic_i
        scalar opt_lag = `i'
    }
}

display "Optimal lag (BIC) = " opt_lag "   min BIC = " min_bic
local p = opt_lag

* Mean equation (AR(p)) and residuals e_t
quietly regress y L(1/`p').y
predict e, resid

* ---------------------------------------------------------
* Step 2: Linearized Stochastic Volatility Setup
* ---------------------------------------------------------
* Constants for log(ε^2), ε~N(0,1)
local m = digamma(.5) + ln(2)
local v = trigamma(.5)

* "Approximately centered" measurement series z_t ≈ h_t + noise
gen z = ln(e^2 + 1e-12) - `m'

* State-space estimation
constraint drop _all
constraint 1 [z]h = 1
constraint 2 [/observable]var(z) = `v'   

quietly sspace (h L.h, state) (z h, noconstant), constraints(1/2)

* Extract latent log-variance and map back to variance/st.dev
predict h_s, states smethod(smooth) equation(h)
gen s2_sv = exp(h_s)
gen sv_sd = sqrt(s2_sv)

* ---------------------------------------------------------
* Step 3: Graphing
* ---------------------------------------------------------
tsline sv_sd, ///
    title("Estimated Stochastic Volatility (SV)") ///
    ytitle("Conditional Standard Deviation") ///
    xtitle("Time") ///
    name(g_sv, replace)

* Export the graph to disk so Word can grab it
graph export "sv_plot.png", as(png) replace name(g_sv)
    
* Overlay y with SV volatility bands
summarize y if !missing(sv_sd), meanonly
gen y_c = y - r(mean)

local k = 2
gen upper =  `k' * sv_sd
gen lower = -`k' * sv_sd

tsline y_c upper lower if !missing(sv_sd), ///
    title("Series y (Demeaned) with SV Volatility Bands (+/-`k'*sd)") ///
    ytitle("y (Demeaned) and Bands") ///
    legend(order(1 "y - mean(y)" 2 "+`k'*sd" 3 "-`k'*sd") ring(0) pos(11)) ///
    name(g_overlay, replace)

* Export the second graph
graph export "sv_overlay.png", as(png) replace name(g_overlay)

* ---------------------------------------------------------
* Step 4: Feasible GLS (FGLS) Estimation
* ---------------------------------------------------------
* Drop invalid weights to prevent regression errors
replace s2_sv = . if s2_sv<=0 | missing(s2_sv)

* Feasible GLS via weighted least squares using the extracted variance
quietly regress y L(1/`p').y [aw=1/s2_sv], vce(robust)

* Capture the full results table
matrix full_res = r(table)'

* FIX: Extract only the first 4 columns (Coef, Std. Err., t, P>|t|) 
* This prevents the putdocx drop error completely!
local r = rowsof(full_res)
matrix fgls_res = full_res[1..`r', 1..4]

* ---------------------------------------------------------
* Step 5: Export to Word via putdocx
* ---------------------------------------------------------
putdocx begin
putdocx paragraph, style("Heading1")
putdocx text ("Ford (F) Stochastic Volatility & FGLS Analysis")

* Section 1: Mean Equation
putdocx paragraph, style("Heading2")
putdocx text ("1. Mean Equation and Optimal Lag Selection")
putdocx paragraph
putdocx text ("To model the mean equation, we iteratively estimated Autoregressive (AR) models from 1 to 31 lags. Using the Bayesian Information Criterion (BIC), which heavily penalizes unnecessary complexity, the optimal lag length was determined to be AR(`p'). This clears the serial correlation from the mean equation, allowing us to isolate the residuals for volatility modeling.")

* Section 2: Stochastic Volatility
putdocx paragraph, style("Heading2")
putdocx text ("2. State-Space Stochastic Volatility (SV) Estimation")
putdocx paragraph
putdocx text ("Unlike standard GARCH models, a Stochastic Volatility model assumes the variance process is driven by its own independent, unobserved shock. To estimate this latent volatility, we applied a linear approximation by taking the log of the squared residuals. This allowed us to format the data into a linear State-Space model. Using the Kalman filter (via Stata's sspace command), we successfully extracted the smoothed, unobserved volatility states.")

* Insert Graphs
putdocx paragraph, halign(center)
putdocx image "sv_plot.png", width(5)
putdocx paragraph, halign(center)
putdocx image "sv_overlay.png", width(5)

putdocx paragraph
putdocx text ("Interpretation of Volatility Bands: "), bold
putdocx text ("The overlay graph displays the demeaned Ford returns bound by +/- 2 conditional standard deviations (extracted from the SV model). Because the variance adapts over time, the bands widen dynamically during periods of market stress (volatility clustering) and narrow during calm periods. A well-fitted SV model will capture roughly 95% of the daily returns within these bands.")

* Section 3: FGLS
putdocx paragraph, style("Heading2")
putdocx text ("3. Feasible Generalized Least Squares (FGLS)")
putdocx paragraph
putdocx text ("Under the presence of heteroskedasticity (volatility clustering), standard Ordinary Least Squares (OLS) estimates are inefficient. To correct this, we re-estimated the AR(`p') mean equation using Feasible Generalized Least Squares (FGLS). By weighting the regression using the inverse of the SV-estimated variance, we down-weight the volatile, noisy periods and place higher mathematical trust in the stable periods, restoring the efficiency of the AR coefficients.")

putdocx paragraph
putdocx text ("FGLS Estimation Results [AR(`p')]:"), bold

* Because we already trimmed the matrix, we just print it and skip the drop command!
putdocx table fgls_tbl = matrix(fgls_res), rownames colnames

* Save the Document
putdocx save "Ford_SV_Analysis.docx", replace

* Cleanup the temporary graph files from the hard drive
erase "sv_plot.png"
erase "sv_overlay.png"
