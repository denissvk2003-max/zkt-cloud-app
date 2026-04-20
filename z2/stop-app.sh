#!/bin/bash
set -e

echo "Stopping Kubernetes app..."

kubectl delete -f deployment.yaml --ignore-not-found=true
kubectl delete -f service.yaml --ignore-not-found=true
kubectl delete -f statefulset.yaml --ignore-not-found=true
kubectl delete -f namespace.yaml --ignore-not-found=true

echo "Kubernetes app stopped."