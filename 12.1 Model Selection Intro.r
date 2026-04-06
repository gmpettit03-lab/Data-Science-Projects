# Model Selection Intro

####### NEW FUNCTIONS ###############

#   regsubsets(M, nvmax = 10)

#   see_models(M, report = 5)

#   step()  # lots of arguments

#   build_model() # Lots of arguments

##############  Oldies but Goodies ########################
#drop1()
#check_regression()
#naive.M

#   see_interactions(M, many = TRUE)

############################################

### Key pdf pages 

#  5-7,8 ,14,21, 24*, 25, 27, 38, 40-1

#  62, 64, 66, 68, 70, 76*, 77-8, 80-1*

library(regclass)

Build <- read.csv("Model Selection.csv")

Build$z1 = factor(Build$z1)
Build$z2  = factor(Build$z2)





## All possible procedure
models <- regsubsets(Y ~ ., data = Build,
                     method="exhaustive")

see_models(models)

see_models(models, report = 8)

models2 <- regsubsets(Y ~ ., data = Build,
                      method="exhaustive"
                      ,nbest = 3)

see_models(models2, report = 8)

Best = lm(Y ~ x1 + x3 +x5 + z1 +z2, data = Build)
summary(Best)



# Example with Interaction predictors

modelint <- regsubsets(Y ~ .^2, data = Build,
                      method="exhaustive"
                      ,nbest = 3, really.big = T)

see_models(modelint, report = 8)


Bestint = lm(Y ~ x1 + x3 +z1 + x3*x4 + x3*x7 + x4*z2 +x7*x10 + x9*z2, data = Build)
summary(Bestint)

see_interactions(Bestint, many= TRUE)

# Search procedure ####

naive.model <- lm(Y~1, data=Build) #naive ALWAYS has formula y~1
full.model <- lm(Y~., data=Build)

# Search for a good model
Sforward <- step(naive.model, # Starting model: naive model
              scope=list(lower=naive.model, upper=full.model), # Range of possible models.
              direction="forward", # Direction of search
              trace=1) # Show detailed steps (1) or not (0).
# Y ~ x1 + z1 + x5 + x3

Sbackward <- step(full.model, # Starting model: full model
              scope=list(lower=naive.model, upper=full.model), # Range of possible models.
              direction="backward", # Direction of search
              trace=1) # Show detailed steps (1) or not (0).
# Y ~ x1 + x3 + x5 + z1

Sboth <- step(naive.model, # Starting model: naive model
              scope=list(lower=naive.model, upper=full.model), # Range of possible models.
              direction="both", # Direction of search
              trace=1) # Show detailed steps (1) or not (0).

# Y ~ x1 + z1 + x5 + x3


summary(Sboth)
summary(Sforward)
summary(Sbackward)



# Search for a good model, with interactions.
# NOTE: step() will preserve model hierarchy.
full.model <- lm(Y~ .^2 , data=Build)



S2 <- step(full.model, # Starting model: full model
           scope=list(lower=naive.model,upper=full.model), # Range of possible models.
           direction="both", # Direction of search.
           trace=1) # Show detailed steps (1) or not (0).

# Y ~ x1 + x2 + x3 + x4 + x5 + x7 + x8 + x9 + x10 + z1 + z2 + x1:x4 + 
# x1:x7 + x1:x10 + x1:z2 + x2:x3 + x2:x4 + x2:x5 + x2:x8 + 
#  x3:x4 + x3:x5 + x3:x7 + x3:z1 + x4:z2 + x5:x8 + x5:x10 + 
#  x7:x10 + x9:z2

summary(S2)


Actual = lm(Y ~ x1 + x3*x4 +z1, data = Build)
summary(Actual)

# Non Hierarchical

Actual = lm(Y ~ x1 + x3*x4 -x3 -x4 +z1, data = Build)
summary(Actual)
