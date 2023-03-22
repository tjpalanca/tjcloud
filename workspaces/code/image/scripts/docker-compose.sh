#!/usr/bin/bash

# Docker Compose
# Orchestration Tool
curl -L "https://github.com/docker/compose/releases/download/v2.0.1/docker-compose-linux-x86_64" \
	-o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose