#!/bin/bash

set -e

echo "=== Setting up Kind cluster ==="

# Create registry container unless it already exists
reg_name='kind-registry'
reg_port='5000'
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"
if [ "${running}" != 'true' ]; then
  echo "Creating local registry container..."
  docker run \
    -d --restart=always -p "${reg_port}:5000" --name "${reg_name}" \
    registry:2
fi

# Create kind cluster
echo "Creating Kind cluster..."
kind create cluster --config=kind-cluster.yaml

# Connect the registry to the cluster network
docker network connect "kind" "${reg_name}" || true

# Install ingress-nginx
echo "Installing ingress-nginx..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for ingress controller to be ready
echo "Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo "=== Kind cluster setup complete! ==="