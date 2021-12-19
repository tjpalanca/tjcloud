#!/usr/bin/bash 

# Create gitpod user
useradd -l -u 33333 -G sudo -md /home/gitpod -s /usr/bin/zsh -p gitpod gitpod 
adduser gitpod sudo 
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create .zshrc so zsh doesn't complain 
touch ~/.zshrc