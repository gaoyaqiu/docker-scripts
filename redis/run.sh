#!/usr/bin/env bash

fail() {
  echo "$*"
  exit
}

echo "run docker service: consul"
echo
echo

mkdir -p /data/lib/redis
mkdir -p /data/logs/redis

chmod 777 /data/lib/redis
chmod 777 /data/logs/redis

docker-compose up -d --build
