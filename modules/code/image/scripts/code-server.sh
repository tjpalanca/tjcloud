#!/usr/bin/bash

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version=4.8.0

# Add a missing node symlink
ln -s /usr/bin/node /usr/lib/code-server/lib/vscode/node
