#!/usr/bin/bash

# Open VS Code Server by GitPod
# https://github.com/gitpod-io/openvscode-server

RELEASE_TAG="openvscode-server-v1.63.0"
RELEASE_ORG="gitpod-io"

wget https://github.com/${RELEASE_ORG}/openvscode-server/releases/download/${RELEASE_TAG}/${RELEASE_TAG}-linux-x64.tar.gz && \
    tar xzf ${RELEASE_TAG}-linux-x64.tar.gz && \
    mv -f ${RELEASE_TAG}-linux-x64 /usr/local/share/openvscode-server && \
    rm -f ${RELEASE_TAG}-linux-x64.tar.gz
