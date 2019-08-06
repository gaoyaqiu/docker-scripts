#!/usr/bin/env bash

fail() {
  echo "$*"
  exit
}

mkdir -p /data/lib/redis
mkdir -p /data/logs/redis

chmod 777 /data/lib/redis
chmod 777 /data/logs/redis

docker-compose up -d --build
