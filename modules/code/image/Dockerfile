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
ARG DEFAULT_USER
RUN /rocker_scripts/default_user.sh "${DEFAULT_USER}"
RUN adduser "$DEFAULT_USER" sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
RUN cp /rocker_scripts/init_set_env.sh /etc/cont-init.d/01_set_env
COPY cont-init.d/02_userconf /etc/cont-init.d/02_userconf

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
RUN su $DEFAULT_USER -s /scripts/tmux.sh
# Docker
COPY scripts/docker.sh /scripts
RUN /scripts/docker.sh
# Kubernetes
COPY scripts/kubectl.sh /scripts
RUN /scripts/kubectl.sh
# Cloud66 Toolbelt
COPY scripts/cx.sh /scripts
RUN /scripts/cx.sh
# S3 command line utility
COPY scripts/s3cmd.sh /scripts
RUN /scripts/s3cmd.sh
# Radian R Console
COPY scripts/radian.sh /scripts
RUN /scripts/radian.sh
# Cron Service
COPY scripts/cron.sh /scripts
RUN /scripts/cron.sh
COPY services.d/cron /etc/services.d/cron

# Code Server
COPY scripts/code-server.sh /scripts
RUN /scripts/code-server.sh
COPY services.d/code-server /etc/services.d/code-server
COPY assets/code-192.png /usr/lib/code-server/src/browser/media/pwa-icon-192.png
COPY assets/code-512.png /usr/lib/code-server/src/browser/media/pwa-icon-512.png
COPY assets/code.png /usr/lib/code-server/src/browser/media/pwa-icon.png
COPY assets/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico

# Xvfb Display
ENV DISPLAY :1
COPY services.d/display /etc/services.d/display

# Expose Ports
EXPOSE 8888 5500 3838 3333

# Init Containers 
CMD ["/init"]
