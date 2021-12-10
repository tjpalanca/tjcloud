# RStudio Server Docker Image
FROM rocker/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Languages 
RUN /rocker_scripts/install_python.sh && /rocker_scripts/install_pyenv.sh
RUN /rocker_scripts/install_julia.sh
COPY install/nodejs.sh /install/nodejs.sh
RUN /install/nodejs.sh

# Copy installer scripts 
COPY install /install

# Developer Tools 
RUN /install/docker.sh 
RUN /install/kubectl.sh 
RUN /install/cx.sh
