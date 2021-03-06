#! /bin/sh
set -eu

echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/nopasswd > /dev/null

usermod --login "$DOCKER_USER" rstudio
usermod -d "/home/$DOCKER_USER" $DOCKER_USER
groupmod -n "$DOCKER_USER" rstudio

export USER="$DOCKER_USER"
export HOME="/home/$DOCKER_USER"
export PATH="$HOME/.local/share/r-miniconda/bin:$PATH"

sed -i "/coder/d" /etc/sudoers.d/nopasswd

# Allow non root user to use docker
usermod -aG docker $DOCKER_USER

# Run VS Code Server
runuser -l $DOCKER_USER -c "\
    USER=$USER \
    HOME=$HOME \
    PATH=$PATH \
    code-server \
    --auth none \
    --disable-telemetry \
    --bind-addr 0.0.0.0:8080 \
    --proxy-domain *.vscode.tjpalanca.com"
