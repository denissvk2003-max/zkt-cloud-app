#!/bin/bash
set -e

echo "Starting Kubernetes app..."

# Vytvorenie namespace
kubectl apply -f namespace.yaml
# Vytvorenie services
kubectl apply -f service.yaml
# Spustenie databázy cez StatefulSet
kubectl apply -f statefulset.yaml
# Spustenie frontend a backend deploymentov
kubectl apply -f deployment.yaml

kubectl rollout status statefulset/postgres -n zkt-notes
kubectl rollout status deployment/backend -n zkt-notes
kubectl rollout status deployment/frontend -n zkt-notes

echo "Application should be available at:"
echo "http://localhost:30080"