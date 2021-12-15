#!/usr/bin/bash

CODE_SERVER_VERSION="3.12.0"

wget "https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VERSION}/code-server_${CODE_SERVER_VERSION}_amd64.deb" \
	-O code-server.deb 
dpkg -i code-server.deb 
rm code-server.deb