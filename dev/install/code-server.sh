#!/usr/bin/bash

wget "https://github.com/cdr/code-server/releases/download/v3.12.0/code-server_3.12.0_amd64.deb" \
	-O code-server.deb 
dpkg -i code-server.deb 
rm code-server.deb