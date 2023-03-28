FROM quay.io/keycloak/keycloak:19.0
LABEL maintainer="TJ Palanca <code@tjpalanca.com>"
LABEL org.opencontainers.image.source="https://github.com/tjpalanca/tjcloud"

COPY social /opt/keycloak/themes/social
COPY full /opt/keycloak/themes/full

CMD ["start-dev"]
