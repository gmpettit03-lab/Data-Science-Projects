#Grayson Pettit PS3 Econometrics


setwd("~/Downloads/Major Course work: Materials/Current Classes/Econometrics I")

sink()
set.seed(582)

library(readr)
library(tidyr)
library(dplyr)
library(regclass)


#Question 5: 

data <- read.csv("loanmain.csv", na.strings=c("NA","NULL", ""))

data


data_filtered <- data %>%
  filter(round %in% c(1, 2))



loan_clean <- data_filtered %>%
  drop_na(type, retail, age, gender, total_profit,
          lnlabor, allloan_end, shutdownall, round, education_college)

loan_clean <- loan_clean %>%
  select(type, retail, age, gender, total_profit,
         lnlabor, allloan_end, shutdownall, round, education_college ) %>% filter(complete.cases(.))


loan_r1 <- loan_clean %>%
  filter(round == 1)

loan_r2 <- loan_clean %>%
  filter(round == 2)

#5a.
table1 <- loan_clean %>% group_by(round) %>% 
  summarise(num= n(),
    type = mean(type, na.rm = TRUE),
    retail = mean(retail, na.rm = TRUE),
    age = mean(age, na.rm = TRUE),
    gender = mean(gender, na.rm = TRUE),
    education_college = mean(education_college, na.rm = TRUE),
    total_profit = mean(total_profit, na.rm = TRUE),
    lnlabor = mean(lnlabor, na.rm = TRUE),
    allloan_end = mean(allloan_end, na.rm = TRUE),
    shutdownall = mean(shutdownall, na.rm = TRUE)
  )



table_by_type <- loan_r1 %>%
  group_by(type) %>%
  summarise(
    retail = mean(retail, na.rm = TRUE),
    age = mean(age, na.rm = TRUE),
    gender = mean(gender, na.rm = TRUE),
    education_college = mean(education_college, na.rm = TRUE),
    total_profit = mean(total_profit, na.rm = TRUE),
    lnlabor = mean(lnlabor, na.rm = TRUE),
    allloan_end = mean(allloan_end, na.rm = TRUE),
    shutdownall = mean(shutdownall, na.rm = TRUE)
  )

#5b. 


M1<-lm(total_profit~type+retail+age+gender+education_college, data=loan_r2)
sum_M1<-summary(M1)
sum_M1$coefficients
M2<-lm(lnlabor~type+retail+age+gender+education_college, data=loan_r2)
sum_M2<-summary(M2)
sum_M2$coefficients
M3<-lm(allloan_end~type+retail+age+gender+education_college, data=loan_r2)
sum_M3<-summary(M3)
sum_M3$coefficients
M4<-lm(shutdownall~type+retail+age+gender+education_college, data=loan_r2)
sum_M4<-summary(M4)
sum_M4$coefficients

#The magnitude of the Type coefficient in model 1 (Total Profit), is 6.89. 
#In model 2 (Log employees) The magnitude for type drops to .046. 
#In model 3 (Firm Borrowing) the magnitude is around .24. 
#However, in model 4 (Shutdown), type's magnitude is only around .044, which is very small. 



# Question 6: 
#coefficient decomposition

#Type on other variables This is the most useful one so its at the top
M5<-lm(type~retail+age+gender+education_college, data=loan_r2)
loan_r2$e2<- M5$residuals


#Model 1 on variables aside from type ### This works
M6<-lm(total_profit~retail+age+gender+education_college, data=loan_r2)
loan_r2$e1_M1<- M6$residuals
M7<-lm(e1_M1~e2, data = loan_r2)
coef_5b_type_M1<- unname(coef(M1)["type"])
coef_5b_type_M1
coef_6_type<- unname(coef(M7)["e2"])
coef_6_type

stopifnot(all.equal(coef_5b_type_M1,coef_6_type, tolerance= 1e-10))

#THESE Two numbers are equal


#Model 2 on variables aside from type ##This works too

M8<-lm(lnlabor~retail+age+gender+education_college, data=loan_r2)
loan_r2$e1_M2<- M8$residuals

M9<-lm(e1_M2~e2, data = loan_r2)

coef_5b_type_M2<- unname(coef(M2)["type"])
coef_5b_type_M2
coef_6_type_M2<- unname(coef(M9)["e2"])
coef_6_type_M2

stopifnot(all.equal(coef_5b_type_M2,coef_6_type_M2, tolerance= 1e-10))

#THESE Two numbers are equal



#Model 3 on variables aside from type ## This also works
M10<-lm(allloan_end~retail+age+gender+education_college, data=loan_r2)
loan_r2$e1_M3<- M10$residuals
M11<-lm(e1_M3~e2, data = loan_r2)

coef_5b_type_M3<- unname(coef(M3)["type"])
coef_5b_type_M3
coef_6_type_M3<- unname(coef(M11)["e2"])
coef_6_type_M3

stopifnot(all.equal(coef_5b_type_M3,coef_6_type_M3, tolerance= 1e-10))

#THESE Two numbers are equal



#Model 4 on variables aside from type ## This also works
M12<-lm(shutdownall~retail+age+gender+education_college, data=loan_r2)
loan_r2$e1_M4<- M12$residuals
M13<-lm(e1_M4~e2, data = loan_r2)

coef_5b_type_M4<- unname(coef(M4)["type"])
coef_5b_type_M4
coef_6_type_M4<- unname(coef(M13)["e2"])
coef_6_type_M4

stopifnot(all.equal(coef_5b_type_M4,coef_6_type_M4, tolerance= 1e-10))

#THESE Two numbers are equal

#Problem 7

#Model 1

lmR2_M1 <-unname(sum_M1$r.squared)

Y_1<- loan_r2$total_profit
Y_1_bar<-mean(Y_1)

Resid_M1 <-M1$residuals

R2_byhand_M1 <- 1- (sum(Resid_M1^2)/(sum((Y_1-Y_1_bar)^2)))

R2_byhand_M1

stopifnot(all.equal(lmR2_M1,R2_byhand_M1, tolerance= 1e-10))
#These are equal 

#The magnitude of the R^2 value means the amount of variation in our outcome Total profit explained by the model and constants.  
#The magnitude of Model 1's R^2 is .014. 

#Model 2
lmR2_M2 <-sum_M2$r.squared

Y_2<-loan_r2$lnlabor
Y_2_bar<-mean(Y_2)

Resid_M2 <-M2$residuals

R2_byhand_M2 <- 1- (sum(Resid_M2^2)/(sum((Y_2-Y_2_bar)^2)))

R2_byhand_M2

stopifnot(all.equal(lmR2_M2,R2_byhand_M2, tolerance= 1e-10))
#These are equal 

#The magnitude of the R^2 value means the amount of variation in our outcome log labor explained by the model and constants.  
#The magnitude of Model 2's R^2 is .007. 


#Model 3
lmR2_M3 <-sum_M3$r.squared

Y_3<-loan_r2$allloan_end
Y_3_bar<-mean(Y_3)

Resid_M3 <-M3$residuals

R2_byhand_M3 <- 1- (sum(Resid_M3^2)/(sum((Y_3-Y_3_bar)^2)))

R2_byhand_M3

stopifnot(all.equal(lmR2_M3,R2_byhand_M3, tolerance= 1e-10))
#These are equal 

#The magnitude of the R^2 value means the amount of variation in our outcome lending amount explained by the model and constants.  
#The magnitude of Model 3's R^2 is .058. 


#Model 4
lmR2_M4 <-sum_M4$r.squared
Y_4<-loan_r2$shutdownall

Y_4_bar<-mean(Y_4)

Resid_M4 <-M4$residuals

R2_byhand_M4 <- 1- (sum(Resid_M4^2)/(sum((Y_4-Y_4_bar)^2)))

R2_byhand_M4

stopifnot(all.equal(lmR2_M4,R2_byhand_M4, tolerance= 1e-10))
#These are equal 

#The magnitude of the R^2 value means the amount of variation in our outcome shutdown  explained by the model and constants.  
#The magnitude of Model 4's R^2 is .0122. 



#Question 8

#BELUGA!!! Epic pill
loan_r2$beluga <- runif(nrow(loan_r2), min = 0, max = 1)


# Re-estimate the 4 models including beluga
MB1 <- lm(total_profit ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB1$coefficients
M1$coefficients

MB2 <- lm(lnlabor ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB2$coefficients
M2$coefficients


MB3 <- lm(allloan_end ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB3$coefficients
M3$coefficients


MB4 <- lm(shutdownall ~ type + retail + age + gender + education_college + beluga, data = loan_r2)
MB4$coefficients
M4$coefficients


#refer to TABLES_OUTPUT_R file

#Because it is a uniform distribution of random noise, the coefficients are effectively the same. 
#There are some very slight changes on M1's Type and controls. 
#There are basically no other significant changes on the type variables across models. 

#Question 9: 

X <- model.matrix(M1)

k<- ncol(X)

H<- X  %*% solve(t(X) %*% X) %*% t(X)

h_ii <- diag(H)

print(head(h_ii))


stopifnot(all(h_ii>=0))
stopifnot(abs(sum(h_ii)-k)< 1e-6)

epsilon_tilda<- Resid_M1/ (1-h_ii)


diff_resid_M1<- abs(Resid_M1-epsilon_tilda)

plot(h_ii, diff_resid_M1, xlab="leverage values", ylab="difference in residuals", main= "leverage stuff")

#This makes sense, most of the observations are near 0, which means they have low leverage values. 
#Higher leverage values do stretch the prediction errors. 
#Basically this is what we expect. This is an upward spread, with increasing leverage, which is what is expected. 
#Thus it does make sense. #Epic #Theory #Stuff




#Question 10

loan_r2$orca<- rnorm(nrow(loan_r2), mean= 0, sd=7)


loan_r2$err_total_profit<- loan_r2$total_profit + loan_r2$orca

M1_orca<- lm(err_total_profit~type+retail+age+gender+education_college, data = loan_r2)
summary(M1_orca)
summary(M1)


loan_r2$narwhal<- rnorm(nrow(loan_r2), mean= 0, sd=2)


loan_r2$err_age<- loan_r2$age + loan_r2$narwhal


M1_narwhal<- lm(total_profit~ type+retail+err_age+gender+education_college, data = loan_r2)
summary(M1_narwhal)

#See Tables_Output_PS3 for the table creation. 

#The narwhal model actually messes up the estimate for type by a bit, the coefficient is larger for type in the narwhal model than the normal model. 
#It also seems to bias the estimates of the coefficients upwards. This makes sense given that the error is being added to the X term. 
#The orca model seems to bias the coefficient estimates downwards for all coefficients. 
#This also makes sense given that the random noise is added to the Y term. 




