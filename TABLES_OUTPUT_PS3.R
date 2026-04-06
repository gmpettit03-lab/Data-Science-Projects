#Grayson Pettit PS3 TABLES, I AM VERY BAD AT MAKING NICE TABLES!


setwd("~/Downloads/Major Course work: Materials/Current Classes/Econometrics I")
set.seed(582)
sink()
install.packages(c("kableExtra", "modelsummary"))




# ==============================
#  LATEX TABLES FOR QUESTIONS (THE LLM USAGE, because I don't know how to make pretty tables.)
# ==============================

# Load libraries
library(readr)
library(dplyr)
library(tidyr)
library(broom)
library(kableExtra)
library(modelsummary)

# -----------------------
# 5 LOAD & CLEAN DATA
# -----------------------
data <- read.csv("loanmain.csv", na.strings = c("NA", "NULL", ""))

req_vars <- c("type","retail","age","gender","total_profit",
              "lnlabor","allloan_end","shutdownall","round","education_college")

loan_clean <- data %>%
  filter(round %in% c(1, 2)) %>%
  drop_na(all_of(req_vars)) %>%
  select(all_of(req_vars))

loan_r1 <- loan_clean %>% filter(round == 1)
loan_r2 <- loan_clean %>% filter(round == 2)



# -----------------------
# 5.A TABLE 1 — SUMMARY STATISTICS (ROUND 1)
# -----------------------

vars_to_summarize <- c("type","retail","age","gender","education_college",
                       "total_profit","lnlabor","allloan_end","shutdownall")

# compute means
col_all   <- loan_r1 %>% summarise(across(all_of(vars_to_summarize), mean, na.rm = TRUE))
col_type0 <- loan_r1 %>% filter(type == 0) %>% summarise(across(all_of(vars_to_summarize), mean, na.rm = TRUE))
col_type1 <- loan_r1 %>% filter(type == 1) %>% summarise(across(all_of(vars_to_summarize), mean, na.rm = TRUE))

table1_df <- tibble::tibble(
  Variable = c("Treated (type = 1)",
               "Retail industry",
               "Owner age",
               "Owner male (gender = 1)",
               "College education",
               "Total profit",
               "Log number of employees",
               "Firm borrowing (allloan_end)",
               "Firm shutdown (shutdownall)"),
  `Round 1: All`     = as.numeric(col_all[1, vars_to_summarize]),
  `Round 1: type = 0`= as.numeric(col_type0[1, vars_to_summarize]),
  `Round 1: type = 1`= as.numeric(col_type1[1, vars_to_summarize])
) %>%
  mutate(across(where(is.numeric), ~round(., 3)))

# Problem 5.A: Produce LaTeX Table 1
table1_latex <- table1_df %>%
  kbl(format = "latex", booktabs = TRUE,
      caption = "Table 1: Summary Statistics (Round 1 Sample)",
      align = "lccc", escape = FALSE) %>%
  kable_styling(latex_options = c("hold_position", "striped"))

# Save Table 1 to .tex file
cat(table1_latex, file = "table1_summary.tex")

# -----------------------
# 5.B TABLE 2 — REGRESSION RESULTS (ROUND 2)
# -----------------------
controls <- c("retail","age","gender","education_college")

M1 <- lm(total_profit ~ type + retail + age + gender + education_college, data = loan_r2)
M2 <- lm(lnlabor ~ type + retail + age + gender + education_college, data = loan_r2)
M3 <- lm(allloan_end ~ type + retail + age + gender + education_college, data = loan_r2)
M4 <- lm(shutdownall ~ type + retail + age + gender + education_college, data = loan_r2)



models_list <- list(
  "(1) Total profit"     = M1,
  "(2) Log employees"    = M2,
  "(3) Firm borrowing"   = M3,
  "(4) Shutdown"         = M4
)

coef_labels <- c(
  "type"              = "Treated (type = 1)",
  "retail"            = "Retail industry",
  "age"               = "Owner age",
  "gender"            = "Owner male (gender = 1)",
  "education_college" = "College education"
)

#The magnitude of the Type coefficient in model 1 (Total Profit), is 6.89. 
#In model 2 (Log employees) The magnitude for type drops to .046. 
#In model 3 (Firm Borrowing) the magnitude is around .24. 
#However, in model 4 (Shutdown), type's magnitude is only around .044, which is very small. 

# Export Table 2 to LaTeX
modelsummary(
  models_list,
  coef_map = coef_labels,
  gof_map = c("nobs", "r.squared"),
  fmt = 3,
  stars = TRUE,
  title = "Table 2: Effect of Treatment on Outcomes (Round 2)",
  output = "table2_regressions.tex"
)

# -----------------------
# 6. HANSEN RESIDUAL REGRESSION CHECKS
# -----------------------

residual_decomp_check <- function(outcome, data_frame, controls, tolerance = 1e-8) {
  # residual from Y~controls
  form_e1 <- as.formula(paste(outcome, "~", paste(controls, collapse = " + ")))
  reg_e1 <- lm(form_e1, data = data_frame)
  e1 <- reg_e1$residuals
  
  # residual from type~controls
  reg_e2 <- lm(type ~ ., data = data_frame %>% select(type, all_of(controls)))
  e2 <- reg_e2$residuals
  
  # e1 on e2
  reg_e1_on_e2 <- lm(e1 ~ e2)
  coef_resid <- coef(reg_e1_on_e2)["e2"]
  
  # full model
  reg_full <- lm(as.formula(paste(outcome, "~ type +", paste(controls, collapse = " + "))), data = data_frame)
  coef_full <- coef(reg_full)["type"]
  
  equal_check <- all.equal(as.numeric(coef_full), as.numeric(coef_resid), tolerance = tolerance)
  
  tibble(
    Outcome = outcome,
    Full_Model_Type = round(as.numeric(coef_full), 6),
    Residual_on_Residual = round(as.numeric(coef_resid), 6),
    Equal_Check = as.character(equal_check)
  )
}

outcomes <- c("total_profit","lnlabor","allloan_end","shutdownall")

resid_checks <- lapply(outcomes, residual_decomp_check,
                       data_frame = loan_r2,
                       controls = controls)

print(resid_checks)


resid_df <- bind_rows(resid_checks)

# Save Hansen check table to LaTeX
resid_latex <- resid_df %>%
  kbl(format = "latex", booktabs = TRUE,
      caption = "Table 3: Hansen Residual Regression Checks",
      align = "lccc", escape = FALSE) %>%
  kable_styling(latex_options = c("hold_position", "striped"))

cat(resid_latex, file = "table3_hansen_check.tex")

# The coefficients are equal for type and e1 on e2. 




# -----------------------
# 7. MANUAL R-SQUARED CHECK (Table 2 Columns 1–4)
# -----------------------
# R^2 = 1 - (sum of squared residuals) / (sum of squared deviations of Y from mean(Y))

compute_r2_manual <- function(model, data, outcome_var) {
  y <- data[[outcome_var]]
  yhat <- fitted(model)
  residuals <- y - yhat
  r2_manual <- 1 - sum(residuals^2) / sum((y - mean(y))^2)
  return(r2_manual)
}

# Compute and check R2 for each model
manual_r2 <- tibble(
  Outcome = c("total_profit", "lnlabor", "allloan_end", "shutdownall"),
  R2_manual = c(
    compute_r2_manual(M1, loan_r2, "total_profit"),
    compute_r2_manual(M2, loan_r2, "lnlabor"),
    compute_r2_manual(M3, loan_r2, "allloan_end"),
    compute_r2_manual(M4, loan_r2, "shutdownall")
  ),
  R2_lm = c(summary(M1)$r.squared, summary(M2)$r.squared,
            summary(M3)$r.squared, summary(M4)$r.squared)
)

# Confirm equality to several digits
manual_r2 <- manual_r2 %>%
  mutate(Equal_Check = abs(R2_manual - R2_lm) < 1e-8)

print(manual_r2)

stopifnot(all(manual_r2$Equal_Check))  # assert all checks are TRUE

cat("\nR-squared manual verification complete — all values match lm() output.\n")


# -----------------------
# PRINT COMPLETION MESSAGE
# -----------------------
cat("\nLaTeX tables successfully saved:\n")
cat(" - table1_summary.tex\n - table2_regressions.tex\n - table3_hansen_check.tex\n")


# -----------------------
# 8. BELUGA: add random var, re-estimate, Table 3 (original vs beluga)
# -----------------------

# choose distribution: runif(0,1).
loan_r2$beluga <- runif(nrow(loan_r2), min = 0, max = 1)


# Re-estimate the 4 models including beluga
MB1 <- lm(total_profit ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB2 <- lm(lnlabor ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB3 <- lm(allloan_end ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB4 <- lm(shutdownall ~ type + retail + age + gender + education_college + beluga, data = loan_r2)

# Build lists for modelsummary: first the original 4 then the beluga variants
models_table3 <- list(
  "Orig (1) Total profit"   = M1,
  "Orig (2) Log employees"  = M2,
  "Orig (3) Firm borrowing" = M3,
  "Orig (4) Shutdown"       = M4,
  "Beluga (1) Total profit" = MB1,
  "Beluga (2) Log employees"= MB2,
  "Beluga (3) Firm borrowing"=MB3,
  "Beluga (4) Shutdown"     = MB4
)

# coef map: include beluga label
coef_labels_with_beluga <- c(
  "type"              = "Treated (type = 1)",
  "retail"            = "Retail industry",
  "age"               = "Owner age",
  "gender"            = "Owner male (gender = 1)",
  "education_college" = "College education",
  "beluga"            = "beluga"
)



# Produce Table 3: show coefficients for type & controls (beluga included in beluga models)
# show nobs, r.squared, adj.r.squared; use many digits for R2 and adj.R2
modelsummary(
  models_table3,
  coef_map = coef_labels_with_beluga,
  gof_map = c("nobs", "r.squared", "adj.r.squared"),
  fmt = 6,
  stars = TRUE,
  title = "Table 3: Original vs With beluga (set.seed(582))",
  output = "table3_beluga.tex"
)

cat("\nTable 3 (beluga) saved to table3_beluga.tex\n")


# -----------------------
# 9. Leverage (h_ii), leave-one-out prediction errors, plotting
# -----------------------
# Use original total_profit model M1 (without beluga)

# leverage values (h_ii)
hii <- hatvalues(M1) # identical to lm.influence(M1)$hat

# confirm non-negativity
if (any(hii < -1e-12)) {
  stop("Some leverage values are negative (unexpected).")
}

# p = number of parameters (including intercept)
p <- length(coef(M1))
sum_h <- sum(hii)

# check sum(h_ii) approx p
if (abs(sum_h - p) > 1e-8) {
  stop(paste0("Sum of leverage (", sum_h, ") does not equal number of parameters p = ", p))
} else {
  cat(sprintf("\nLeverage check: sum(h_ii) = %.6f; p = %d (OK)\n", sum_h, p))
}

# least squares residuals
e_i <- residuals(M1)

# leave-one-out prediction error (Hansen eqn / standard LOOCV identity)
# \tilde{ε}_i = e_i / (1 - h_ii)
tilde_e_i <- e_i / (1 - hii)

# difference between tilde_e_i and least-squares residual e_i
diff_tilde_minus_e <- tilde_e_i - e_i

# quick summary
leverage_df <- tibble(
  id = seq_along(e_i),
  y = loan_r2$total_profit,
  resid = e_i,
  hii = hii,
  tilde_resid = tilde_e_i,
  diff = diff_tilde_minus_e
)

print(leverage_df %>% summarise(
  n = n(),
  min_hii = min(hii),
  max_hii = max(hii),
  sum_hii = sum(hii),
  mean_abs_diff = mean(abs(diff))
))

# Plot diff vs hii and save
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
library(ggplot2)

p_leverage <- ggplot(leverage_df, aes(x = hii, y = diff)) +
  geom_point(alpha = 0.6) +
  geom_smooth(se = FALSE, method = "loess") +
  labs(
    title = "Difference between LOOCV prediction error and LS residual vs leverage (total_profit model)",
    x = expression(h[ii]),
    y = expression(tilde(epsilon)[i] - epsilon[i])
  ) +
  theme_minimal()

ggsave("leverage_diff_plot.png", p_leverage, width = 7, height = 5, dpi = 300)
cat("\nLeverage difference plot saved to leverage_diff_plot.png\n")


# -----------------------
# 10. Measurement error experiments and Table 4
# -----------------------
# A) err_total_profit = total_profit + orca (orca ~ N(0,7))
set.seed(582 + 1) # new seed for reproducibility of this sim
loan_r2$orca <- rnorm(nrow(loan_r2), mean = 0, sd = 7)
loan_r2$err_total_profit <- loan_r2$total_profit + loan_r2$orca

M1_errY <- lm(err_total_profit ~ type + retail + age + gender + education_college, data = loan_r2)

# B) err_age = age + narwhal (narwhal ~ N(0,2))
set.seed(582 + 2)
loan_r2$narwhal <- rnorm(nrow(loan_r2), mean = 0, sd = 2)
loan_r2$err_age <- loan_r2$age + loan_r2$narwhal

M1_errAge <- lm(total_profit ~ type + retail + err_age + gender + education_college, data = loan_r2)

# Table 4: 3 columns: original M1, M1_errY, M1_errAge
models_table4 <- list(
  "Orig (total_profit)" = M1,
  "err_total_profit"     = M1_errY,
  "err_age (age measured with error)" = M1_errAge
)

# produce Table 4 with coefficients + nobs + r.squared + adj.r.squared; many digits for R2s
modelsummary(
  models_table4,
  coef_map = coef_labels_with_beluga, # same labels (err_age will appear as 'err_age' variable)
  gof_map = c("nobs", "r.squared", "adj.r.squared"),
  fmt = 6,
  stars = TRUE,
  title = "Table 4: Measurement Error Experiments (total_profit models)",
  output = "table4_measurement_error.tex"
)

cat("\nTable 4 (measurement error) saved to table4_measurement_error.tex\n")

# Optional: print concise comparison numbers to console
compare_r2_table4 <- tibble(
  Model = names(models_table4),
  nobs = sapply(models_table4, function(m) length(residuals(m))),
  R2 = sapply(models_table4, function(m) summary(m)$r.squared),
  Adj_R2 = sapply(models_table4, function(m) summary(m)$adj.r.squared)
)
print(compare_r2_table4)






