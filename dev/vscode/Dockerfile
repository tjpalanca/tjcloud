FROM ghcr.io/tjpalanca/tjcloud/rstudio:latest
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

# Install Radian
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install -U radian jupyter

# Install Julia
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.0-linux-x86_64.tar.gz \
    -O julia.tar.gz && \
    tar zxvf julia.tar.gz && \
    mv julia-1.7.0 /usr/local/share/julia && \
    ln -s /usr/local/share/julia/bin/julia /usr/local/bin/julia

# Install code server binary
ENV CODER_VERSION=3.12.0
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh

# Expose ports and set user
EXPOSE 8080
ENTRYPOINT ["bin/sh"]
CMD ["-c", "set -ex && Xvfb :99 & export DISPLAY=:99 && /usr/bin/entrypoint.sh"]
