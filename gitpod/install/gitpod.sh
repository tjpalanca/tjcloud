#!/usr/bin/bash 

# Create gitpod user
useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod 

# passwordless sudo for users in the 'sudo' group
touch /etc/sudoers
sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers