#!/usr/bin/bash

# Open VS Code Server by GitPod
# https://github.com/gitpod-io/openvscode-server

RELEASE_TAG=" openvscode-server-insiders-v1.64.0"
RELEASE_NME="${RELEASE_TAG}-linux-x64"
RELEASE_TAR="${RELEASE_NME}.tar.gz"
RELEASE_ORG="gitpod-io"

wget https://github.com/${RELEASE_ORG}/openvscode-server/releases/download/${RELEASE_TAG}/${RELEASE_TAR} && \
    tar xzf ${RELEASE_TAG} && \
    mv -f ${RELEASE_NME} /usr/local/share/openvscode-server && \
    rm -f ${RELEASE_TAR}
