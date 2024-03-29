FROM ghcr.io/rocker-org/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"
LABEL org.opencontainers.image.source="https://github.com/tjpalanca/tjcloud"

# Scripts
RUN mkdir -p /scripts

# Linux 
COPY scripts/linux.sh /scripts
RUN /scripts/linux.sh

# Initialization 
RUN /rocker_scripts/install_s6init.sh
ENV DEFAULT_USER="tjpalanca"
RUN /rocker_scripts/default_user.sh ${DEFAULT_USER}
RUN cp /rocker_scripts/init_set_env.sh /etc/cont-init.d/01_set_env

# R
COPY scripts/r-deps.sh /scripts
RUN /scripts/r-deps.sh
# Python
COPY scripts/python-deps.sh /scripts
RUN /scripts/python-deps.sh
RUN /rocker_scripts/install_python.sh 
# Julia
COPY scripts/julia-deps.sh /scripts
RUN /scripts/julia-deps.sh
COPY scripts/julia.sh /scripts
RUN /scripts/julia.sh
# NodeJS
COPY scripts/nodejs.sh /scripts
RUN /scripts/nodejs.sh

# Sudo Permissions
COPY scripts/sudo.sh /scripts
RUN /scripts/sudo.sh
# Terminal Multiplexer (tmux)
COPY scripts/tmux.sh /scripts
RUN su ${DEFAULT_USER} -s /scripts/tmux.sh
# Docker
COPY scripts/docker.sh /scripts
RUN /scripts/docker.sh
# Kubernetes
COPY scripts/kubectl.sh /scripts
RUN /scripts/kubectl.sh
# S3 command line utility
COPY scripts/s3cmd.sh /scripts
RUN /scripts/s3cmd.sh
# Quarto 
COPY scripts/quarto.sh /scripts 
RUN /scripts/quarto.sh

# Cron Service
COPY scripts/cron.sh /scripts
RUN /scripts/cron.sh
COPY services.d/cron /etc/services.d/cron
# Xvfb Display
ENV DISPLAY :1
COPY services.d/display /etc/services.d/display

# Code Server
COPY scripts/code-server.sh /scripts
RUN /scripts/code-server.sh
COPY services.d/code-server /etc/services.d/code-server
COPY media/code-192.png /usr/lib/code-server/src/browser/media/pwa-icon-192.png
COPY media/code-512.png /usr/lib/code-server/src/browser/media/pwa-icon-512.png
COPY media/code.png /usr/lib/code-server/src/browser/media/pwa-icon.png
COPY media/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico
COPY media/fonts/ /usr/lib/code-server/src/browser/media/fonts/

# Expose Ports
EXPOSE 8888 5500 3838 3333

# Init Containers 
CMD ["/init"]
