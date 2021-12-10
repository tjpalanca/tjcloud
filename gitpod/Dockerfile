# RStudio Server Docker Image
FROM rocker/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Languages 
RUN /rocker_scripts/install_python.sh && /rocker_scripts/install_pyenv.sh
RUN /rocker_scripts/install_julia.sh
COPY install/nodejs.sh /install/nodejs.sh
RUN /install/nodejs.sh

# Developer Tools 
COPY install/gitpod.sh /install
RUN /install/gitpod.sh
COPY install/zsh.sh /install
RUN /install/zsh.sh
ENV SHELL zsh
COPY install/oh-my-zsh.sh /install
RUN su gitpod -s /install/oh-my-zsh.sh
COPY install/docker.sh /install
RUN /install/docker.sh 
COPY install/kubectl.sh /install
RUN /install/kubectl.sh
COPY install/cx.sh /install 
RUN /install/cx.sh
COPY install/tailscale.sh /install
RUN /install/tailscale.sh
COPY install/radian.sh /install
RUN /install/radian.sh
COPY install/jupyter.sh /install
RUN /install/jupyter.sh

# Copy other install and examples 
COPY install /install
COPY examples /examples