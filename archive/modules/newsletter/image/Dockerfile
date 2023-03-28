FROM ubuntu:jammy 

LABEL maintainer="Troy James Palanca <code@tjpalanca.com>"
LABEL org.opencontainers.image.source="https://github.com/tjpalanca/tjcloud"

# Linux Dependencies
RUN apt-get update && apt-get install -y \
    wget

# Install Kill the Newsletter
RUN mkdir -p /kill-the-newsletter
WORKDIR /kill-the-newsletter
RUN wget \
    https://github.com/leafac/kill-the-newsletter/releases/download/v1.0.1/kill-the-newsletter--linux--v1.0.1.tgz \
    -O kill-the-newsletter.tgz && \
    tar -xvf kill-the-newsletter.tgz && \
    rm kill-the-newsletter.tgz
COPY configuration.js .

# Environment
ENV NODE_ENV=production

# Expose Ports 
EXPOSE 2525 8080

# Command 
ENTRYPOINT ["./kill-the-newsletter"]
CMD ["configuration.js"]
