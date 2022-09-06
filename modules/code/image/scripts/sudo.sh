#!/usr/bin/bash 

adduser rstudio sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
