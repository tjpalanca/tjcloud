#!/usr/bin/bash 

# Git Large File Storage
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
	apt-get update && apt-get install -y git-lfs
