gen y = F

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

* 1) mean equation (AR(p)) and residuals e_t
regress y L(1/`p').y
predict e, resid

* 2) constants for log(ε^2), ε~N(0,1)
* E[ln(ε^2)] = digamma(1/2) + ln(2)
* Var[ln(ε^2)] = trigamma(1/2) = π^2/2
local m = digamma(.5) + ln(2)
local v = trigamma(.5)

* 3) "approximately centered" measurement series z_t ≈ h_t + noise
gen z = ln(e^2 + 1e-12) - `m'

* 4) state-space:
*    z_t = 1*h_t + u_t
*    h_t = c + rho*h_{t-1} + eta_t
constraint drop _all
constraint 1 [z]h = 1
constraint 2 [/observable]var(z) = `v'   // fix measurement-error variance to π^2/2

sspace (h L.h, state) (z h, noconstant), constraints(1/2)

* 5) extract latent log-variance and map back to variance
predict h_s, states smethod(smooth) equation(h)
gen s2_sv = exp(h_s)

* ---- Plot estimated stochastic volatility (variance or st.dev.) ----
gen sv_sd = sqrt(s2_sv)

tsline sv_sd, ///
    title("Estimated stochastic volatility (SV): sqrt(exp(h_t))") ///
    ytitle("Conditional sd") ///
    xtitle("Time") ///
	name(g_sv, replace)
	
* ---- Overlay y with SV volatility bands ----
summarize y if !missing(sv_sd), meanonly
gen y_c = y - r(mean)

local k = 2
gen upper =  `k' * sv_sd
gen lower = -`k' * sv_sd

tsline y_c upper lower if !missing(sv_sd), ///
    title("Series y (demeaned) with SV volatility bands (+/-`k'*sd)") ///
    ytitle("y (demeaned) and bands") ///
    legend(order(1 "y - mean(y)" 2 "+`k'*sd" 3 "-`k'*sd") ring(0) pos(11)) ///
	name(g_overlay, replace)

gen y_w = y / sqrt(s2_sv)
forvalues j=1/`p' {
    gen Ly_w`j' = L`j'.y / sqrt(s2_sv)
}

* Drop first p obs if needed (lags create missings)
* Ensure weights are positive and finite
replace s2_sv = . if s2_sv<=0 | missing(s2_sv)

* Feasible GLS via weighted least squares
regress y L(1/`p').y [aw=1/s2_sv], vce(robust)