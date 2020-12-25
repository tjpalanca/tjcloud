FROM openjdk:8-jre
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

RUN mkdir -p /opt/shinyproxy/
COPY bin/shinyproxy-2.4.2.jar /opt/shinyproxy/shinyproxy.jar
COPY assets /opt/shinyproxy/assets
COPY template /opt/shinyproxy/templates/template
COPY application.yml /opt/shinyproxy/application.yml

WORKDIR /opt/shinyproxy/
CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
