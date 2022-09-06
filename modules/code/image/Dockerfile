FROM ghcr.io/rocker-org/r-ver:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Scripts
RUN mkdir -p /scripts

# Python
RUN /rocker_scripts/install_python.sh 

# Julia
COPY scripts/julia.sh /scripts
RUN /scripts/julia.sh

# NodeJS
COPY scripts/nodejs.sh /scripts
RUN /scripts/nodejs.sh

# # Core Dependencies
# COPY install/linux.sh /install
# RUN /install/linux.sh
# COPY install/r-deps.sh /install
# RUN /install/r-deps.sh
# COPY install/julia-deps.sh /install
# RUN /install/julia-deps.sh
# COPY install/python-deps.sh /install
# RUN /install/python-deps.sh

# # Sudo Permissions
# COPY install/sudo.sh /install
# RUN /install/sudo.sh
# # Terminal Multiplexer (tmux)
# COPY install/tmux.sh /install
# RUN su rstudio -s /install/tmux.sh
# # Docker
# COPY install/docker.sh /install
# RUN /install/docker.sh
# # Kubernetes
# COPY install/kubectl.sh /install
# RUN /install/kubectl.sh
# # Cloud66 Toolbelt
# COPY install/cx.sh /install
# RUN /install/cx.sh
# # S3 command line utility
# COPY install/s3cmd.sh /install
# RUN /install/s3cmd.sh
# # Radian R Console
# COPY install/radian.sh /install
# RUN /install/radian.sh

# # RStudio Server
# COPY install/rstudio-server.sh /install
# RUN /install/rstudio-server.sh
# # VS Code via code-server
# COPY install/code-server.sh /install
# RUN /install/code-server.sh
# COPY services.d/code-server /etc/services.d/code-server
# COPY code/assets/code-192.png /usr/lib/code-server/src/browser/media/pwa-icon-192.png
# COPY code/assets/code-512.png /usr/lib/code-server/src/browser/media/pwa-icon-512.png
# COPY code/assets/code.png /usr/lib/code-server/src/browser/media/pwa-icon.png
# COPY code/assets/favicon.ico /usr/lib/code-server/src/browser/media/favicon.ico
# # Cron Service
# COPY install/cron.sh /install
# RUN /install/cron.sh
# COPY services.d/cron /etc/services.d/cron

# User Configuration
COPY cont-init.d/02_userconf /etc/cont-init.d/02_userconf

# Xvfb Display
ENV DISPLAY :1
COPY services.d/display /etc/services.d/display

# # Expose Ports
EXPOSE 8888 5500 3838 8787 8788 8789
