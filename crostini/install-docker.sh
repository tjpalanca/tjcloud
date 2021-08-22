#!/bin/bash

# Basic dependencies
sudo apt-get update && \
  sudo apt-get -y install \
  nano \
  wget \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  gnupg2

# Add docker repository
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io || exit 1

# Allow $USER to manage Docker
sudo usermod -aG docker troypalanca

# Temporary workaround
# https://github.com/docker/for-linux/issues/475
sudo mkdir -p /etc/systemd/system/containerd.service.d
echo "[Service]
ExecStartPre=" | sudo tee /etc/systemd/system/containerd.service.d/override.conf
sudo systemctl daemon-reload

# Test docker
sudo service docker restart || exit 1
docker run --rm hello-world || exit 1

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
