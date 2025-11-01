#!/bin/bash

echo "=== Tearing down Ticketboard Platform ==="

# Delete Kubernetes resources with Kustomize
echo "Deleting Kubernetes resources..."
kubectl delete -k k8s/frontend/ --ignore-not-found=true
kubectl delete -k k8s/backend/ --ignore-not-found=true
kubectl delete -k k8s/database/ --ignore-not-found=true
kubectl delete -k k8s/base/ --ignore-not-found=true

# Delete Kind cluster
echo "Deleting Kind cluster..."
kind delete cluster --name=ticketboard-cluster

# Remove local registry
echo "Removing local registry..."
docker stop kind-registry 2>/dev/null || true
docker rm kind-registry 2>/dev/null || true

echo "=== Teardown complete ==="