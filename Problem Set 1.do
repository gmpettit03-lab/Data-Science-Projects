********PROBLEM SET 1****************
*************************************
cd "C:\Users\bigfo\Desktop\HANSEN MACRO\data"

clear

putpdf clear

putpdf begin

*******2.3.1 #3*********************
************************************
use ARexamples.dta

tsset time

tsline X in 2900/3000, title("Last 100 Observations of X")

graph export "tsplot.png", replace

putpdf paragraph, halign(center)
putpdf image "tsplot.png"

putpdf paragraph
putpdf text ("AR(1) Model")

regress X L.X, nocons

putpdf table tbl_x = etable

*******2.3.1 #4*********************
************************************

tsline Y in 2900/3000, title("Last 100 Observations of Y")

graph export "tsplot2.png", replace

putpdf paragraph, halign(center)
putpdf image "tsplot2.png"

putpdf paragraph
putpdf text ("AR(2) Model")

regress Y L(1/2).Y, nocons

putpdf table tbl_y = etable

*******2.3.1 #5*********************
************************************

tsline Z in 2900/3000, title("Last 100 Observations of Z")

graph export "tsplot3.png", replace

putpdf paragraph, halign(center)
putpdf image "tsplot3.png"

putpdf paragraph
putpdf text ("AR(3) Model")

regress Z L(1/3).Z, nocons

putpdf table tbl_z = etable

*******2.3.1 #6*********************
************************************

regress Z L.Z L3.Z, nocons

putpdf paragraph
putpdf text ("AR(3) Model Restricted (lag2=0)")

putpdf table tbl_zr = etable

*******2.3.2 #1*********************
************************************
putpdf pagebreak

preserve // This saves your current ARexamples data in the background
clear

* 1. Create the data structure from your Excel sheet
input period A B C D E
0 1 1 1 1 1
1 0.5 -0.5 0.5 0.5 1
2 0.25 0.25 0.15 0.05 1
3 0.125 -0.125 0.025 -0.075 1
4 0.0625 0.0625 -0.0025 -0.0475 1
5 0.03125 -0.03125 -0.00375 -0.00875 1
end

* 2. Add the table to your PDF
putpdf paragraph, halign(center)
putpdf text ("Hand-Calculated Impulse Response Functions (Periods 0-5)")

* Create the table using the data we just 'input'
putpdf table irf_table = data(period A B C D E), varnames border(all)

* Format the headers to look like your Excel sheet
putpdf table irf_table(1,.), font("Helvetica", 10) bold bgcolor("lightgray")
putpdf table irf_table(1,1) = ("Period")
putpdf table irf_table(1,2) = ("(a) 0.5Xt-1")
putpdf table irf_table(1,3) = ("(b) -0.5Xt-1")
putpdf table irf_table(1,4) = ("(c) AR(2)")
putpdf table irf_table(1,5) = ("(d) AR(2)+C")
putpdf table irf_table(1,6) = ("(e) Random Walk")


putpdf paragraph
putpdf text ("The positive IRF from part A decays monotonoically, while the negative IRF from part B shrinks but moves between positive and negative coefficients each period. Because there are multiple lags in parts C and D, the coefficients are less consistent, with a wave form appearing in Part D as it moves from positive to negative to slightly less negative. Parts A through D are all stationary and should be approaching 0. E is non-stationary and stays at 1 forever.")

restore

*******2.3.3 #2*********************
************************************

putpdf pagebreak

* 1. Run the model
arima Z, ar(1/3) nocons nolog

* 2. Start PDF and add the regression table
putpdf paragraph
putpdf text ("AR(3) Model using Arima"), bold
putpdf table reg_tab = etable

* 3. Expand the dataset and forecast
tsappend, add(10)

* IMPORTANT: Use dynamic(3001) to forecast based on previous predictions
predict Zhat, dynamic(3001)

* 4. Add the data table to the PDF
putpdf paragraph
putpdf text ("Forecasted Values (Obs 3001-3010):"), bold

* This captures the actual data values for the rows you want
putpdf table forecast_tab = data(Z Zhat) in 2998/3010, varnames border(all)

* 5. Save
putpdf save "problemset1.pdf", replace
