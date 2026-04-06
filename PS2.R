

x= c(20, 8, 1, 12, 3, 1, 10, 4, 1, 10 ,8, 1, 8, 1, 1)
X=matrix(data=x, nrow = 5, ncol = 3, byrow = TRUE)
print(X)
y=c(142,18,41,133,7)
Y=matrix(data=y, nrow = 5, ncol = 1, byrow = TRUE)
print(Y)

df <- data.frame(X, Y)

colnames(df) <- c("X1", "X2", "X3", "Y")

print(df)

M=lm(Y~., data = df)
summary(M)

XTX<-t(X) %*% X
InvXTX<-solve(XTX)

XTY<-t(X) %*% Y
B<-InvXTX %*% XTY
#annhiliator matrix
i5=c(1,0,0,0,0, 0, 1,0,0,0, 0,0,1,0,0,0,0,0,1,0, 0,0,0,0,1)
I5=matrix(data=i5, nrow = 5, ncol = 5, byrow = TRUE)
print(I5)
P= X %*% InvXTX %*% t(X)
print(P)
M=I5-P
print(M)

#This is basically 0
M %*% M - M

#c)
M2 <- lm(Y ~ X1 + X2, data = df)
summary(M2)
M2$coefficients
B1_direct <- coef(M2)["X1"]
B1_direct


proj_M <- lm(X1 ~ X2, data = df)
u1 <- resid(proj_M) 
u1
B1_decomp <- sum(u1 * y) / sum(u1^2)
B1_decomp

# Check, This is basically 0 
B1_direct-B1_decomp


#d)
#SSE

SSE<-sum((Y - X %*% B)^2)
SSE

# Restart, because I had to look up how to do this
x1 <- c(20, 12, 10, 10, 8)
x2 <- c(8, 3, 4, 8, 1)
y  <- c(142, 18, 41, 133, 7)

df <- data.frame(x1, x2, y)


model <- lm(y ~ x1 + x2, data = df)
beta_hat <- coef(model)
beta1_hat <- beta_hat["x1"]

sse_hat <- sum(resid(model)^2)
cat("SSE at OLS solution:", sse_hat, "\n")
cat("OLS β1:", beta1_hat, "\n\n")

#10 SSEs

grid_beta1 <- seq(beta1_hat - 5, beta1_hat + 5, length.out = 10) 
sse_values <- numeric(length(grid_beta1))

for (i in seq_along(grid_beta1)) {
 
  b1 <- grid_beta1[i]
  
  y_adj <- y - b1 * x1
  
  temp_model <- lm(y_adj ~ x2, data = df)
  
  y_fitted <- b1 * x1 + fitted(temp_model)
  
  resid_i <- y - y_fitted
  sse_values[i] <- sum(resid_i^2)
}

### (3) Plot SSE vs B1
plot(grid_beta1, sse_values,
     xlab = expression(hat(beta)[1]), ylab = "SSE",
     main = "SSE as F(B1)")

# Add vertical line at min SSE B1
abline(v = beta1_hat, col = "red", lwd = 2, lty = 2)
legend("topright", legend = c("OLS B1"), col = "red", lty = 2, lwd = 2)



library(readr)
library(tidyr)
library(dplyr)
DATA <- read_csv("CollegeScorecardInstitution_2024.csv")



CLEAN<- DATA %>%
  select(UNITID, MD_EARN_WNE_P10, SAT_AVG, DEBT_MDN, ADM_RATE, ICLEVEL, MAIN, HIGHDEG, CONTROL) %>% 
  filter(ICLEVEL == 1, MAIN == 1, HIGHDEG == 4, CONTROL==1) %>%
  filter(complete.cases(.)) %>%
  select(-ICLEVEL, -MAIN, -HIGHDEG, -CONTROL)



CLEAN<- CLEAN %>% mutate(SAT_CAT = ntile(SAT_AVG, 4), ADM_CAT = ntile(ADM_RATE,4) )


CEF_1 <- CLEAN %*% group_by(SAT_CAT, ADM_CAT) %>% summarise(MDEARN_MU= mean(MD_EARN_WNE_P10))



