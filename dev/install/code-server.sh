#!/usr/bin/bash

VERSION="4.0.1"

wget "https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server_${VERSION}_amd64.deb" \
	-O code-server.deb
# wget "https://tjpalanca.sgp1.digitaloceanspaces.com/bin/code-server_${VERSION}_amd64.deb" \
#     -O code-server.deb
dpkg -i code-server.deb
rm code-server.deb
