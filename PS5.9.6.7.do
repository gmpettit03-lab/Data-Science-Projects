clear all
set more off

* 1. Load the Data
use "/Users/graysonpettit/Downloads/Major Course work: Materials/Spring 2026/ECON 523/data/arch-F.dta", clear

* Ensure time series is set
tsset time

* ---------------------------------------------------------
* 2. Estimate Models and Store Conditional Variances & IC
* ---------------------------------------------------------
* Note: We use 'quietly' to suppress the massive wall of iteration output
* so your Stata console doesn't get flooded.

* Model 1: ARCH(10)
quietly arch F, arch(1/10)
estat ic
matrix ic_arch10 = r(S)
predict v_arch10, variance

* Model 2: GARCH(1,1)
quietly arch F, arch(1) garch(1)
estat ic
matrix ic_garch11 = r(S)
predict v_garch11, variance

* Model 3: GARCH-M (GARCH-in-Mean)
quietly arch F, arch(1) garch(1) archm
estat ic
matrix ic_garchm = r(S)
predict v_garchm, variance

* Model 4: GJR-GARCH (Threshold GARCH in Stata syntax)
quietly arch F, arch(1) garch(1) tarch(1)
estat ic
matrix ic_gjr = r(S)
predict v_gjr, variance

* Model 5: E-GARCH (Exponential GARCH)
quietly arch F, earch(1) egarch(1)
estat ic
matrix ic_egarch = r(S)
predict v_egarch, variance

* ---------------------------------------------------------
* 3. Combine AIC/BIC Results into a Single Matrix
* ---------------------------------------------------------
* In the estat ic return matrix (r(S)), column 5 is AIC and column 6 is BIC.
matrix IC_RESULTS = J(5, 2, .)
matrix rownames IC_RESULTS = "ARCH(10)" "GARCH(1,1)" "GARCH-M" "GJR-GARCH" "E-GARCH"
matrix colnames IC_RESULTS = "AIC" "BIC"

matrix IC_RESULTS[1,1] = ic_arch10[1,5]
matrix IC_RESULTS[1,2] = ic_arch10[1,6]
matrix IC_RESULTS[2,1] = ic_garch11[1,5]
matrix IC_RESULTS[2,2] = ic_garch11[1,6]
matrix IC_RESULTS[3,1] = ic_garchm[1,5]
matrix IC_RESULTS[3,2] = ic_garchm[1,6]
matrix IC_RESULTS[4,1] = ic_gjr[1,5]
matrix IC_RESULTS[4,2] = ic_gjr[1,6]
matrix IC_RESULTS[5,1] = ic_egarch[1,5]
matrix IC_RESULTS[5,2] = ic_egarch[1,6]

* ---------------------------------------------------------
* 4. Calculate Correlation of Conditional Variances
* ---------------------------------------------------------
correlate v_arch10 v_garch11 v_garchm v_gjr v_egarch
matrix corr_matrix = r(C)

* ---------------------------------------------------------
* 5. Export to Word via putdocx
* ---------------------------------------------------------
putdocx begin
putdocx paragraph, style("Heading1")
putdocx text ("Ford (F) Volatility Model Comparison")

putdocx paragraph, style("Heading2")
putdocx text ("1. Model Selection: AIC and BIC Comparison")
putdocx paragraph
putdocx text ("We estimated five volatility models: ARCH(10), GARCH(1,1), GARCH-M, GJR-GARCH, and E-GARCH. The Akaike Information Criterion (AIC) and Bayesian Information Criterion (BIC) are summarized below (lower values indicate a better fit).")

* Insert and format the IC table
putdocx table ic_tbl = matrix(IC_RESULTS), rownames colnames
putdocx table ic_tbl(., .), nformat("%8.2f")

putdocx paragraph
putdocx text ("AIC/BIC Interpretation: "), bold
putdocx text ("When you review the generated table, look for the lowest values. In financial equities, asymmetric models (like GJR-GARCH and E-GARCH) usually yield the best AIC/BIC scores. This is because they account for the 'leverage effect'—the phenomenon where bad news (negative returns) spikes market volatility significantly more than good news (positive returns) of the exact same magnitude.")

putdocx paragraph, style("Heading2")
putdocx text ("2. Correlation of Conditional Variances")
putdocx paragraph
putdocx text ("After estimating the models, we predicted the conditional variance series for each. The correlation matrix below shows how similarly these models track the day-to-day volatility of Ford's returns.")

* Insert and format the Correlation table
putdocx table corr_tbl = matrix(corr_matrix), rownames colnames
putdocx table corr_tbl(., .), nformat("%8.4f")

putdocx paragraph
putdocx text ("Correlation Interpretation: "), bold
putdocx text ("You will likely see that the conditional variances are highly correlated (often > 0.90), particularly among the GARCH variants. This proves that while the models differ in their mathematical nuances and asymmetric penalties, they are all ultimately identifying the exact same underlying volatility clustering in the Ford data. The ARCH(10) model's variance will likely have the lowest correlation with the others, as it lacks the long-memory persistence of the GARCH terms.")

putdocx save "Ford_Volatility_Comparison.docx", replace
