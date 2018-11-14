rm(list=ls())
library(leaps)
library(tidyverse)
library(pbmcapply)

perf <- function(X_test, y_test, theta, theta.star) {
  
  nzero <- which(theta != 0)
  zero  <- which(theta == 0)
  
  true.nzero <- which(theta.star != 0)
  true.zero  <- which(theta.star == 0)
  
  TP <- sum(nzero %in% true.nzero)
  TN <- sum(zero %in%  true.zero)
  FP <- sum(nzero %in% true.zero)
  FN <- sum(zero %in%  true.nzero)
  
  recall    <- TP/(TP + FN) ## also recall and sensitivity
  fallout   <- FP/(FP + TN) ## also 1 - specificit
  precision <- TP/(TP + FP) ## also PPR
  recall[TP + FN == 0] <- NA
  fallout[TN + FP == 0] <- NA
  precision[TP + FP == 0] <- NA

  rmse <- sqrt(mean((theta - theta.star)^2, na.rm = TRUE))
  rerr <- sqrt(mean((y_test - X_test %*% theta)^2))
  res <-  round(c(fallout,recall,precision, rmse, rerr),4)
  res[is.nan(res)] <- 0
  names(res) <- c("fallout","recall", "precision", "rmse", "prediction") 
  res
}


rlm <- function(n.train, p, p0, r2, n.test=10*n.train) {
  ## génération ensemble test/apprentissage
  n <- n.train + n.test
  train <- sample(1:n, n.train)
  test  <- setdiff(1:n, train)

  ## vecteur des vrais coefficients
  beta <- numeric(p)
  A <- sample(1:p, p0)
  beta[A] <- runif(p0, 1, 2)
  ## bruit blanc gaussien 
  noise <- rnorm(n, 0, 1)  
  ## prédicteurs sans structure particulière
  X <- matrix(rnorm(n*p), n, p)
  ## vecteur d'observation des réponses
  sigma <- sqrt( (1-r2)/r2 * c(t(beta) %*% cov(X) %*% beta))
  y <- X %*% beta + sigma * noise

  list(y=y, X=X, beta=beta, sigma=sigma, train=train, test=test)
}

getStepAIC <- function(X, y) {
  p <- ncol(X)
  regss <- regsubsets(
    X,
    y,
    method = "forward",
    nvmax = p,
    really.big = TRUE,
    intercept = FALSE
  )
  regss_summary <- summary(regss)
  id_AIC <- which.min(regss_summary$cp)
  beta <- rep(0, p)
  beta[regss_summary$which[id_AIC, ]] <- coef(regss, id_AIC)
  beta
}

getStepBIC <- function(X, y) {
  p <- ncol(X)
  regss <- regsubsets(
    X,
    y,
    method = "forward",
    nvmax = p,
    really.big = TRUE,
    intercept = FALSE
  )
  regss_summary <- summary(regss)
  id_BIC <- which.min(regss_summary$bic)
  beta <- rep(0, p)
  beta[regss_summary$which[id_BIC, ]] <- coef(regss, id_BIC)
  beta
}

getOneSimu <- function(i) {
  data <- rlm(100, 50, 10, r2 = .75)
  
  beta_AIC <- getStepAIC(data$X[data$train, ], data$y[data$train])
  beta_BIC <- getStepBIC(data$X[data$train, ], data$y[data$train])
  
  res <-
    data.frame(
      rbind(
        perf(data$X[data$test, ], data$y[data$test], beta_AIC, data$beta),
        perf(data$X[data$test, ], data$y[data$test], beta_BIC, data$beta)
      )
    ) %>% 
    add_column(method = c("stepAIC", "stepBIC")) %>% 
    add_column(simu_label = i)
  res
}

n_simu <- 10
res <- Reduce("rbind", pbmclapply(1:n_simu, getOneSimu, mc.cores = 2))

ggplot(res, aes(x = method, y = rmse)) + geom_boxplot()