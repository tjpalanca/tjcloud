#!/usr/bin/bash

apt-get remove -y rstudio-server 
wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-2021.09.1-372-amd64.deb \
    -O rstudio-server.deb 
gdebi --non-interactive rstudio-server.deb 
rm rstudio-server.deb
