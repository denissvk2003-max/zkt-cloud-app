#!/bin/bash
set -e

# Skript slúži na prípravu aplikácie pred nasadením.
# Skontroluje potrebné súbory a lokálne otestuje Docker build.

echo "Preparing Render deployment..."

# Kontrola, či existujú hlavné súbory
echo "Checking files..."
test -f render.yaml
test -f backend/Dockerfile
test -f frontend/Dockerfile
test -f backend/app.py
test -f frontend/index.html

echo "Local Docker build test..."

# Lokálny test zostavenia backend image
docker build -t render-backend-test ./backend

# Lokálny test zostavenia frontend image
docker build -t render-frontend-test ./frontend

echo "Preparation finished."
echo "Push this folder to GitHub, then create Render Blueprint from sk1/render.yaml."