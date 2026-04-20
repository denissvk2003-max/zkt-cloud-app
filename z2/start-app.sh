#!/bin/bash
set -e

echo "Starting Kubernetes app..."

kubectl apply -f namespace.yaml
kubectl apply -f service.yaml
kubectl apply -f statefulset.yaml
kubectl apply -f deployment.yaml

kubectl rollout status statefulset/postgres -n zkt-notes
kubectl rollout status deployment/backend -n zkt-notes
kubectl rollout status deployment/frontend -n zkt-notes

echo "Application should be available at:"
echo "http://localhost:30080"