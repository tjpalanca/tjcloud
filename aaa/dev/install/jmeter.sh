#!/usr/bin/bash

# Apache JMeter 
# Load testing tool
wget \
    https://tjpalanca.sgp1.digitaloceanspaces.com/bin/apache-jmeter-5.4.1.tgz \
    -O jmeter.tgz && \
    tar xzvf jmeter.tgz && \
    rm jmeter.tgz && \
    mv apache-jmeter-5.4.1 /usr/local/lib/apache-jmeter-5.4.1 && \
	ln -s /usr/local/lib/apache-jmeter-5.4.1/bin/jmeter /usr/local/bin/jmeter
