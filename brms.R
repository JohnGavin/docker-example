# cf https://github.com/JohnGavin/soccer_ha_covid/blob/master/brms/00_start_here_brms.R

docker run --platform linux/amd64 -ti --rm --privileged ghcr.io/jbris/stan-cmdstanr-docker:latest R -q --no-save
# ghcr.io/jbris/stan-cmdstanr-docker WORKS 
	# brms / rstan / tidyverse / # cmdstanr WORKS / ALL included 
	# https://github.com/JBris/stan-cmdstanr-docker#stan
options()$brms.backend ; options()$auto_write ; options()$mc.cores ; options()$bspm.sudo
str(Sys.info()) ; 
capture.output(system("g++ -v"))
# install.packages("cmdstanr", lib = .libPaths()[2])
list.files(.libPaths()[1])
# library(cmdstanr) ; 

library(rstan)
(num_cores <- parallel::detectCores())
system.time( example(stan_model, package = "rstan", run.dontrun = TRUE) )

# https://github.com/JBris/stan-cmdstanr-docker/blob/main/brms_within_chain_parallelization.R
library(tidyverse)
library(brms)
set.seed(54647)
# number of observations
N <- 1E4
# number of group levels
G <- round(N / 10)
# number of predictors
P <- 3
# regression coefficients
beta <- rnorm(P)
# sampled covariates, group means and fake data
fake <- matrix(rnorm(N * P), ncol = P)
dimnames(fake) <- list(NULL, paste0("x", 1:P))
# fixed effect part and sampled group membership
fake <- transform(
  as.data.frame(fake),
  theta = fake %*% beta,
  g = sample.int(G, N, replace=TRUE)
)
# add random intercept by group
fake  <- merge(fake, data.frame(g = 1:G, eta = rnorm(G)), by = "g")
# linear predictor
fake  <- transform(fake, mu = theta + eta)
# sample Poisson data
fake  <- transform(fake, y = rpois(N, exp(mu)))
# shuffle order of data rows to ensure even distribution of computational effort
fake <- fake[sample.int(N, N),]
# drop not needed row names
rownames(fake) <- NULL
model_poisson <- brm(
  y ~ 1 + x1 + x2 + (1 | g),
  data = fake,
  family = poisson(),
  iter = 500, # short sampling to speedup example
  chains = 2,
  prior = prior(normal(0,1), class = b) +
    prior(constant(1), class = sd, group = g),
  backend = "cmdstanr",
  threads = threading(4)
)
summary(model_poisson)

# BUT epilepsy RUNS but with 3 compile errors wrt Eigen!
head(epilepsy)
library(brms) ; fit1 <- brm(count ~ zAge + zBase * Trt + (1|patient), data = epilepsy, family = poisson())


# image too OLD
# docker run --platform linux/amd64 -ti --rm --privileged lcolling/brms R -q --no-save

