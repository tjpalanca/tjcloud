FROM openjdk:8-jre
LABEL maintainer="TJ Palanca <code@tjpalanca.com>"

RUN mkdir -p /opt/shinyproxy/
WORKDIR /opt/shinyproxy
RUN wget https://tjpalanca.ap-south-1.linodeobjects.com/bin/shinyproxy-2.5.0.jar \
  -O shinyproxy.jar
COPY template template
COPY application.yml application.yml

CMD ["java", "-jar", "/opt/shinyproxy/shinyproxy.jar"]
