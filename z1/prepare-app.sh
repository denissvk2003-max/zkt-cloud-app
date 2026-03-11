#!/bin/bash
set -e

echo "Preparing app..."

docker network create zkt_app_net 2>/dev/null || true
docker volume create zkt_db_data 2>/dev/null || true

docker compose build

echo "App prepared."