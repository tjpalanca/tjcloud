FROM ghcr.io/tjpalanca/tjcloud/rstudio:latest
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

# Install code server binary
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install Radian
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install -U radian

# Copy entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Expose ports
EXPOSE 8080
ENTRYPOINT ["bin/sh"]
CMD ["-c", "set -ex && Xvfb :99 & export DISPLAY=:99 && /usr/bin/entrypoint.sh"]
