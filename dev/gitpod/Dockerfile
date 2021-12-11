FROM rocker/geospatial:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Python and Julia
RUN /rocker_scripts/install_python.sh && \
	/rocker_scripts/install_pyenv.sh && \
	/rocker_scripts/install_julia.sh

# Install scripts
RUN mkdir -p /install

# NodeJS 
COPY install/nodejs.sh /install 
RUN /install/nodejs.sh

# Core Dependencies
COPY install/linux.sh /install 
RUN /install/linux.sh
COPY install/r-deps.sh /install 
RUN /install/r-deps.sh
COPY install/julia-deps.sh /install 
RUN /install/julia-deps.sh

# GitPod User
COPY install/gitpod.sh /install/gitpod.sh
RUN /install/gitpod.sh

# Oh My Zsh!
COPY install/oh-my-zsh.sh /install
RUN su gitpod -s /install/oh-my-zsh.sh

# Docker
COPY install/docker.sh /install 
RUN /install/docker.sh
# Kubernetes
COPY install/kubectl.sh /install 
RUN /install/kubectl.sh
# Cloud66 Toolbelt
COPY install/cx.sh /install 
RUN /install/cx.sh

# Radian R Console
COPY install/radian.sh /install 
RUN /install/radian.sh
# Jupyter
COPY install/jupyter.sh /install 
RUN /install/jupyter.sh
# Pluto.jl
COPY install/plutojl.sh /install 
RUN su gitpod -s /install/plutojl.sh

# Copy examples 
COPY gitpod/example /example

# Change to zsh login shell 
ENV SHELL /usr/bin/zsh