clear

cd "C:\Users\bigfo\Desktop\Metrics II"

use nsw_dw.dta

log using ProblemSet2_583.log, replace
eststo clear

*************************
****Part (A)*************
*************************
gen age2 = age^2

teffects ra (re78 age age2 educ black hispanic married nodegree re74 re75) (treat), ate
			
teffects ra (re78 age age2 educ black hispanic married nodegree re74 re75) (treat), atet

***The ATE and ATT are not equal, with the ATE coefficient equal to 1601 and the ATET equal to 1784. Though roughly similar, the difference probably lies in the actual treatment effect on individuals, meaning that there is heterogenity across individuals in the sample despite randomization.

**************************
****Part (B)**************
**************************
drop if treat == 0 

tab treat

append using cps_controls3.dta

replace age2 = age^2

tab treat

save nsw_cps_obs.dta, replace

summarize age educ black hispanic married nodegree re74 re75 if treat==1
summarize age educ black hispanic married nodegree re74 re75 if treat==0

teffects ra (re78 age age2 educ black hispanic married nodegree re74 re75) (treat), ate
			
teffects ra (re78 age age2 educ black hispanic married nodegree re74 re75) (treat), atet

***They are not close to being equal, with the ATE coefficient being 636 while ATET is 1701. They would be different because they are looking at completely different populations, where ATE is examinining everyone in the sample's interaction with the treatment, while ATET is strictly looking at individuals who recieved the treatment. Because treated individuals differ systematically from controls in terms of covariates, and because treatment effects likely vary with these characteristics, the two estimands differ. In the context of the study, the job training program may have larger effects for the disadvantaged individuals who selected into treatment, implying that the ATT differs from the ATE.

****************************
****Part (C)****************
****************************

reg re78 age age2 educ black hispanic married nodegree re74 re75 if treat==1
predict double m1hat_all if e(sample), xb

matrix b1 = e(b)

reg re78 age age2 educ black hispanic married nodegree re74 re75 if treat==0
predict double m0hat, xb

***Individual Treatment effects
gen te_i = m1hat - m0hat

summarize te_i

******The ATE estimates manually computed coincide with the ATE produced by teffects ra

*****************************
****Part (D)*****************
*****************************

eststo ra_att: teffects ra (re78 age age2 educ black hispanic married nodegree re74 re75) (treat), atet

eststo ipw_att: teffects ipw (re78) (treat age age2 educ black hispanic married nodegree re74 re75), atet

eststo psm_att:
teffects psmatch (re78) (treat age age2 educ black hispanic married nodegree re74 re75), atet

eststo aipw_att: teffects aipw (re78 age age2 educ black hispanic married nodegree re74 re75) (treat age age2 educ black hispanic married nodegree re74 re75), atet

esttab ra_att ipw_att psm_att aipw_att using att_results.tex, replace se star(* 0.10 ** 0.05 *** 0.01) mtitles("RA" "IPW" "PSM" "AIPW") booktabs


*****The ATT coefficient computed using regression adjustment was 1701, and all three alternative methods of estimation were lower, but within the same ballpark. Inverse probability weighting provided a coefficient of 1439, while propensity score matching provided the closest estimate of 1525. The augmented inverse probability weighting was the farthest from the regression adjustment, with a coefficient of 1373. 


*****************************
****Part (E)*****************
*****************************

logit treat age age2 educ black hispanic married nodegree re74 re75

predict pscore

teffects psmatch (re78) (treat age age2 educ black hispanic married nodegree re74 re75)

teoverlap

****** The overlap figure provides some context on the concentration of observations in reference to the probability of recieving treatment. There is a minimal amount of overlap between treated and untreated individuals, with the only overlap occuring between .5 and .8 propensity range. This is concerning because the overlap only occurs where there is low density, while the spike in untreated observations around propensity score 1 implies that our control group is highly likely to be treated, and the highest concentration of treated individuals are in the low propensity score range. I would thus say that the overlap condition is extremely weak, but does not entirely fail. 

log close 
