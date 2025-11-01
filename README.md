# Ticketboard Infrastructure

Kubernetes infrastructure with Kustomize for the Ticketboard platform.

## Structure

k8s/
├── base/ # Base resources (namespace, ingress)
├── database/ # PostgreSQL configuration
├── backend/ # Backend API configuration
├── frontend/ # Frontend application configuration
└── overlays/ # Environment-specific overrides

## Quick Start

### Local Development with Kind

```bash
# Setup Kind cluster
./scripts/setup-kind.sh

# Deploy everything
./scripts/deploy-all.sh

# Health check
./scripts/health-check.sh

# Teardown
./scripts/teardown.sh
```

## Local Development with Docker Compose

docker-compose -f docker-compose.local.yaml up --build

## Access

- Frontend: <http://localhost>
- Backend API: <http://localhost/api>
- Health Check: <http://localhost/api/health>

## Environments

- Development: kubectl apply -k k8s/overlays/development/
- Production: kubectl apply -k k8s/overlays/production/
