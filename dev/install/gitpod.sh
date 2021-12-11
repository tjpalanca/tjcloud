#!/usr/bin/bash 

# Create gitpod user
useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod 
