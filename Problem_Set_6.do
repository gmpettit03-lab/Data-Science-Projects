clear all
set more off

import delimited "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/clean_macro_data.csv", clear

* 1. Convert the string text into a Stata daily numeric date
gen daily_date = date(date, "YMD")

* 2. Convert that daily date into a quarterly date
gen qdate = qofd(daily_date)

* 3. Format it so it reads cleanly in your data browser (e.g., 1960q2)
format qdate %tq

* 4. Declare the dataset as a time series using the new quarterly variable
tsset qdate

* ==============================================================================
* Step 1 & 2: Replicate the 5-equation model & IRFs of Galí 1999 
* ==============================================================================
* Galí (1999) identifies a technology shock by assuming it is the ONLY shock 
* that can affect labor productivity in the long run.
* Define a lower-triangular long-run restriction matrix (10 constraints total)
matrix LR = (., 0, 0, 0, 0 \ ///
             ., ., 0, 0, 0 \ ///
             ., ., ., 0, 0 \ ///
             ., ., ., ., 0 \ ///
             ., ., ., ., .)

* Estimate the Long-Run SVAR
svar dlprod hours inflation fedfunds dmoney, lags(1/4) lreq(LR)

* Generate and graph the IRFs for the technology shock (Bootstrapped for SEs)
irf create gali_irf, set(myirfs, replace) step(20) bs reps(50)
irf graph sirf, impulse(dlprod) response(dlprod hours inflation fedfunds dmoney) name(gali_graph, replace) title("Galí 1999: Tech Shock IRFs")

* ==============================================================================
* Step 3: Save the estimated tech shock as a time series (Manual Matrix Algebra)
* ==============================================================================
* 1. Predict the 5 reduced-form residuals (u_t)
predict res1, residuals equation(dlprod)
predict res2, residuals equation(hours)
predict res3, residuals equation(inflation)
predict res4, residuals equation(fedfunds)
predict res5, residuals equation(dmoney)

* 2. Extract the structural B matrix that Stata estimated, and invert it
matrix B = e(B)
matrix invB = inv(B)

* 3. Calculate the structural technology shock (e_t)
gen estimated_tech_shock = invB[1,1]*res1 + invB[1,2]*res2 + invB[1,3]*res3 + invB[1,4]*res4 + invB[1,5]*res5

* Drop the temporary residuals to keep your dataset clean
drop res1 res2 res3 res4 res5

* ==============================================================================
* Step 4, 5 & 6: Re-run using IV-SVAR with Short-Run CEE Restrictions
* ==============================================================================
* We will use your 'estimated_tech_shock' as an instrument/proxy.
* The CEE framework identifies a monetary policy shock by assuming the Fed observes 
* output and inflation before setting rates, meaning output/prices do not react 
* contemporaneously to the interest rate (a short-run lower triangular matrix).

* Define the short-run Cholesky (lower triangular) matrix
matrix SR = (., 0, 0, 0, 0 \ ///
             ., ., 0, 0, 0 \ ///
             ., ., ., 0, 0 \ ///
             ., ., ., ., 0 \ ///
             ., ., ., ., .)


* Estimate the Short-Run SVAR (CEE Restrictions)
svar dlprod hours inflation fedfunds dmoney, aeq(SR)
* ==============================================================================
* Step 7: Show the resulting IRFs
* ==============================================================================
irf create iv_irf, set(myirfs) step(20)

* IRFs for the Technology Shock (assuming it remains the 1st variable/equation)
irf graph sirf, impulse(dlprod) response(dlprod hours inflation fedfunds dmoney) name(iv_tech, replace) title("IV-SVAR: Tech Shock IRFs")

* IRFs for the Monetary Policy Shock (CEE identifies this as the interest rate, the 4th variable)
irf graph sirf, impulse(fedfunds) response(dlprod hours inflation fedfunds dmoney) name(iv_mp, replace) title("IV-SVAR: Monetary Policy Shock IRFs")

* ==============================================================================
* Step 8: Is the VAR stable?
* ==============================================================================
varstable, graph

* ==============================================================================
* Step 9: Granger Causality Wald Test
* ==============================================================================
vargranger

* ==============================================================================
* Step 10: Forecast Error Variance Decomposition (FEVD)
* ==============================================================================
* Generate a table showing the variance decomposition
irf table fevd, impulse(dlprod fedfunds) response(dlprod hours inflation fedfunds dmoney)

* Graph the FEVD for a visual representation
irf graph fevd, impulse(dlprod fedfunds) response(dlprod hours inflation fedfunds dmoney) name(fevd_graph, replace) title("FEVD: Tech vs Monetary Shocks")
