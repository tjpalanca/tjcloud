#!/usr/bin/bash 

adduser $DEFAULT_USER sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
