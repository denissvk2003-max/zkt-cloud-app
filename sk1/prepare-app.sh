#!/bin/bash
set -e

echo "Preparing Render deployment..."

echo "Checking files..."
test -f render.yaml
test -f backend/Dockerfile
test -f frontend/Dockerfile
test -f backend/app.py
test -f frontend/index.html

echo "Local Docker build test..."
docker build -t render-backend-test ./backend
docker build -t render-frontend-test ./frontend

echo "Preparation finished."
echo "Push this folder to GitHub, then create Render Blueprint from sk1/render.yaml."