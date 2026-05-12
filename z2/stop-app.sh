#!/bin/bash
set -e

echo "Stopping Kubernetes app..."

# Odstránenie deploymentov
kubectl delete -f deployment.yaml --ignore-not-found=true
# Odstránenie services
kubectl delete -f service.yaml --ignore-not-found=true
# Odstránenie StatefulSet databázy
kubectl delete -f statefulset.yaml --ignore-not-found=true
# Odstránenie namespace
kubectl delete -f namespace.yaml --ignore-not-found=true

echo "Kubernetes app stopped."