#!/bin/bash
set -e

echo "Preparing Kubernetes app..."

docker build -t z2-backend:latest ./backend
docker build -t z2-frontend:latest ./frontend

echo "Images built successfully."
echo "Now run ./start-app.sh"