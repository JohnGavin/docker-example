# copy .history file into docker contain or map volume?
# https://jsta.github.io/r-docker-tutorial/04-Dockerhub.html


rstan - fedora command? 20.04 v 22.04 v 

# -v $(pwd):/mnt uses the -v a:b options to make local directory a available as b in the container; here $(pwd) calls print working directory to get the local directory which is now mapped to /mnt in the container
# fix for platform warning --platform linux/amd64/v8 --privileged 

# https://github.com/Chuan-Peng-Lab/Rstudio_docker
# this docker image does NOT work on MAC M1 chip. 
# on some Mac book, this docker image does not work perfectly: 
# 	brms, only work when using cmdstanr backend, NOT RSTAN

# cmdstanr WORKS 
# ghcr.io/jbris/stan-cmdstanr-docker WORKS 
# https://github.com/JBris/stan-cmdstanr-docker
docker run --platform linux/amd64 -ti --rm --privileged ghcr.io/jbris/stan-cmdstanr-docker:latest bash
R -q --no-save
library(rstan) 
(num_cores <- parallel::detectCores())
options(mc.cores = num_cores)
rstan_options(auto_write = TRUE) # avoid recompilation of unchanged Stan programs
options()$brms.backend ; options()$auto_write ; options()$mc.cores ; 
options()$bspm.sudo
system.time( example(stan_model, package = "rstan", run.dontrun = TRUE) )
# https://github.com/JBris/stan-cmdstanr-docker/blob/main/brms_within_chain_parallelization.R
	# https://cran.r-project.org/web/packages/brms/vignettes/brms_threading.html#fake-data-simulation

# localhost:$R_STUDIO_PORT 
# https://github.com/JBris/stan-cmdstanr-docker/blob/main/Dockerfile
# https://github.com/JBris/stan-cmdstanr-docker/blob/main/brms_within_chain_parallelization.R


# tidyverse -> rstan WORKS 
# rocker/tidyverse 'rstan' WORKS but requires install.packages("rstan") each time!?
docker run --platform linux/amd64 -ti --rm --privileged rocker/tidyverse R -q --no-save
# rocker/r-bspm:22.04 FAILS (Boost not found; call install.packages('BH'))
# docker run --platform linux/amd64 -ti --rm --privileged rocker/r-bspm:22.04 R -q --no-save
# docker run --platform linux/amd64 -ti --rm --privileged rocker/rstan 	 R -q --no-save
system.time( install.packages("rstan") ) # apt -y update; apt install -y r-cran-rstan 
library(rstan) 
(num_cores <- parallel::detectCores())
options(mc.cores = num_cores)
rstan_options(auto_write = TRUE) # avoid recompilation of unchanged Stan programs
system.time( example(stan_model, package = "rstan", run.dontrun = TRUE) )


# rstan FAILS r-bspm:22.04 / r-bspm:20.04
docker run --platform linux/amd64 -ti --rm --privileged rocker/r-bspm:22.04 R -q --no-save
# docker run -ti --rm jrnold/rstan R -q

list.files(.libPaths()[1])

remove.packages(c("BH", "StanHeaders", "rstan")[1], lib = .libPaths()[2])
# Error: package or namespace load failed for ‘BH’:
# package ‘BH’ was installed before R 4.0.0: please re-install it

# r-cran-bh apt-get command? r-cran-stanheaders  r-cran-rstan
system.time( install.packages('BH', lib = .libPaths()[2] ))
library(BH)
system.time( install.packages('rstan', lib = .libPaths()[2]) ) # 23 elapsed
# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started#verifying-installation
?rstan 
example(stan_model, package = "rstan", run.dontrun = TRUE)

parallel::detectCores()
options(mc.cores = parallel::detectCores())
# To avoid recompilation of unchanged Stan programs
rstan_options(auto_write = TRUE)

system.time( install.packages("StanHeaders", repos = c("https://mc-stan.org/r-packages/", getOption("repos")), dependencies = TRUE ) )
system.time( install.packages("rstan", repos = c("https://mc-stan.org/r-packages/", getOption("repos")), dependencies = TRUE ) )
system.time( example(stan_model, package = "rstan", run.dontrun = TRUE) )





library("rstan")
options(auto_write = FALSE, mc.cores = 1)
options()$brms.backend ; options()$auto_write ; options()$mc.cores ; 
options()$bspm.sudo

# Simulating some data
n     = 10
y     = rnorm(n,1.6,0.2)

# Running stan code
model = stan_model("./stan/stan_em_1.stan")
# Error in sink(type = "output") : invalid connection

fit = sampling(model,list(n=n,y=y),iter=200,chains=4)

print(fit)

params = extract(fit)

par(mfrow=c(1,2))
ts.plot(params$mu,xlab="Iterations",ylab="mu")
hist(params$sigma,main="",xlab="sigma")
