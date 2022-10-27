#!/usr/bin/bash

# Download quarto
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.2.247/quarto-1.2.247-linux-amd64.deb \
    -O quarto.deb

# Install deb file
gdebi --non-interactive quarto.deb

# Remove installer
rm quarto.deb
