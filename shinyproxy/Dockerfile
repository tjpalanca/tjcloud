FROM openjdk:8-jre
LABEL maintainer="TJ Palanca <mail@tjpalanca.com>"

RUN mkdir -p /opt/shinyproxy/
WORKDIR /opt/shinyproxy
COPY bin/shinyproxy-2.5.0.jar shinyproxy.jar
COPY template template
COPY application.yml application.yml

CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
