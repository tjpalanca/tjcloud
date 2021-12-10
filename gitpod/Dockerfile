# RStudio Server Docker Image
FROM rocker/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Setup GitPod
COPY install/gitpod.sh /install/gitpod.sh
RUN /install/gitpod.sh

# Setup Terminal
COPY install/zsh.sh /install
RUN /install/zsh.sh
ENV SHELL zsh
COPY install/oh-my-zsh.sh /install
RUN su gitpod -s /install/oh-my-zsh.sh

# Copy other install and examples 
COPY install /install
COPY example /example
COPY setup /setup
