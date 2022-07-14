#!/usr/bin/bash

# Install code-server 4.5.0
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=4.5.0

# Add a missing node symlink
ln -s /usr/bin/node /usr/lib/code-server/lib/vscode/node
