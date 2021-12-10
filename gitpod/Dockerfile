# RStudio Server Docker Image
FROM rocker/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Linux Minimums
RUN apt-get update && \
	apt-get install -y \
	curl htop nano git sudo gnupg make wget \
    software-properties-common gdebi-core apt-transport-https 

# Setup GitPod
COPY install/gitpod.sh /install/gitpod.sh
RUN /install/gitpod.sh

# Setup Terminal
COPY install/zsh.sh /install
RUN /install/zsh.sh
COPY install/oh-my-zsh.sh /install
RUN su gitpod -s /install/oh-my-zsh.sh
ENV SHELL zsh

# Copy other install and examples 
COPY install /install
COPY example /example
COPY setup /setup
