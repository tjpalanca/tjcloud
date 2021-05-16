FROM tjpalanca/apps:rstudio-latest
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

# Install code server binary
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Expose ports
EXPOSE 8080
ENTRYPOINT ["bin/sh"]
CMD ["-c", "set -ex && Xvfb :99 & export DISPLAY=:99 && /usr/bin/entrypoint.sh"]
