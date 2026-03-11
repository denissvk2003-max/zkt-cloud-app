#!/bin/bash
set -e

echo "Removing app..."

docker compose down --remove-orphans

docker volume rm zkt_db_data 2>/dev/null || true
docker network rm zkt_app_net 2>/dev/null || true

echo "Removed app."