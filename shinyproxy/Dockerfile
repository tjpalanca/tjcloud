FROM openjdk:8-jre
LABEL maintainer="TJ Palanca <code@tjpalanca.com>"

RUN mkdir -p /opt/shinyproxy/
WORKDIR /opt/shinyproxy
COPY wget https://tjpalanca.sgp1.digitaloceanspaces.com/bin/shinyproxy-2.5.0.jar \
  -O shinyproxy.jar
COPY template template
COPY application.yml application.yml

CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
