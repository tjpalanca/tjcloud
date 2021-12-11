#!/bin/sh
set -eu

# Modify Users
sudo echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null
sudo usermod --login "$DOCKER_USER" rstudio
sudo usermod -d "/home/$DOCKER_USER" $DOCKER_USER
sudo groupmod -n "$DOCKER_USER" rstudio
sudo sed -i "/coder/d" /etc/sudoers.d/nopasswd

# Paths
export USER="$DOCKER_USER"
export HOME="/home/$DOCKER_USER"
export PATH="$HOME/.local/share/r-miniconda/bin:$PATH"
export SERVICE_URL="$CODER_SERVICE_URL"
export ITEM_URL="$CODER_ITEM_URL"

# Allow non root user to use docker
usermod -aG docker $DOCKER_USER

# Run VS Code Server
runuser -l $DOCKER_USER -c "\
    USER=$USER \
    HOME=$HOME \
    PATH=$PATH \
    SERVICE_URL=$SERVICE_URL \
    ITEM_URL=$ITEM_URL \
    code-server \
    --auth none \
    --disable-telemetry \
    --bind-addr 0.0.0.0:8080 \
    --proxy-domain *.$PROXY_DOMAIN"
