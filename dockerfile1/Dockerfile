# docker build --tag doc_em --build-arg GITHUB_PAT=foobar  .
# docker run --env DATABASE_URL=loremipsum doc_em
# 	DATABASE_URL via --env flag accessible as an env var at _run_time


# https://matthewrkaye.com/posts/series/doing-data-science/2023-06-03-docker/docker.html
	# renv::restore() in the CI itself (before running the docker build ...),
	# keep R version in container in sync with version on local
	# Rscript -e "renv::init()"

FROM rocker/bspm:4.3.0
# FROM rocker/r-ver:4.3.0

# downloading private Github package 
# 	so u need a GITHUB_PAT env var 
# 	set GITHUB_PAT as a build ARG
# GITHUB_PAT as a build arg at build time NOT at runtime
ARG GITHUB_PAT
# docker build --tag example --build-arg GITHUB_PAT=foobar .
## Note: don't actually do this
RUN echo "GITHUB_PAT=$GITHUB_PAT"
# GITHUB_PAT that you set as a build arg is no longer accessible at runtime. It’s only accessible at build time

COPY renv /renv
COPY renv.lock renv.lock
# map container
# COPY .Rprofile .Rprofile
# COPY .Rhistory .Rhistory 
COPY example.R example.R

# copying all of the renv scaffolding into the image. And instead of 
# running install.packages(...), we’ve replaced that line with 
# renv::restore() which will look at the lockfile and install packages as 
# they’re defined.  
RUN Rscript -e "if (!requireNamespace('renv')) install.packages('renv')"
RUN Rscript -e "renv::restore()"
 
RUN Rscript -e "install.packages('glue')"

CMD ["Rscript", "example.R"]
# CMD ["Rscript", "-e", "'Hello from Docker!'"]

