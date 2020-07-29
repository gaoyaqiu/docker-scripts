#!/usr/bin/env bash
set -euo pipefail

docker build -f Dockerfile -t sonarqube:8.4.1-community-local .
docker run -p 19000:9000 sonarqube:8.4.1-community-local
