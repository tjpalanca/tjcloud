FROM rocker/geospatial:4
LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"

# Python and Julia
ENV JULIA_VERSION=1.7.1
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

# Sudo Permissions 
COPY install/sudo.sh /install 
RUN /install/sudo.sh
# Terminal Multiplexer (tmux)
COPY install/tmux.sh /install 
RUN su rstudio -s /install/tmux.sh
# Docker
COPY install/docker.sh /install 
RUN /install/docker.sh
# Kubernetes
COPY install/kubectl.sh /install 
RUN /install/kubectl.sh
# Cloud66 Toolbelt
COPY install/cx.sh /install 
RUN /install/cx.sh
# S3 command line utility
COPY install/s3cmd.sh /install 
RUN /install/s3cmd.sh
# Radian R Console
COPY install/radian.sh /install 
RUN /install/radian.sh

# RStudio Server
COPY install/rstudio.sh /install
RUN /install/rstudio.sh
# VS Code 
COPY install/code-server.sh /install
RUN /install/code-server.sh
COPY services.d/code-server /etc/services.d/code-server
COPY code/assets/code-192.png /usr/lib/code-server/vendor/modules/code-oss-dev/resources/server/code-192.png
COPY code/assets/code-512.png /usr/lib/code-server/vendor/modules/code-oss-dev/resources/server/code-512.png
COPY code/assets/favicon.ico /usr/lib/code-server/vendor/modules/code-oss-dev/resources/server/favicon.ico
# COPY install/openvscode-server.sh /install
# RUN /install/openvscode-server.sh
# COPY services.d/openvscode-server /etc/services.d/openvscode-server
# COPY code/assets/code-192.png /usr/local/share/openvscode-server/resources/server/code-192.png
# COPY code/assets/code-512.png /usr/local/share/openvscode-server/resources/server/code-512.png
# COPY code/assets/favicon.ico /usr/local/share/openvscode-server/resources/server/favicon.ico

# User Configuration
COPY cont-init.d/userconf /etc/cont-init.d/userconf

# Cleanup Zombie Processes
COPY services.d/cleanup /etc/services.d/userconf

# Xvfb Display
ENV DISPLAY :1
COPY services.d/display /etc/services.d/display

# Virtual Host Routing
COPY services.d/nginx /etc/services.d/nginx

# Expose Ports
EXPOSE 8888 5050 3838 8789
