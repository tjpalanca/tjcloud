#!/usr/bin/bash

apt-get remove -y rstudio-server 
wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-2022.02.0-preview-392-amd64.deb \
    -O rstudio-server.deb 
gdebi --non-interactive rstudio-server.deb 
rm rstudio-server.deb
