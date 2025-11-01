#!/bin/bash

set -e

echo "Waiting for database to be ready..."

MAX_RETRIES=30
RETRY_COUNT=0

until kubectl get pods -n ticketboard -l app=postgres 2>/dev/null | grep -q "Running" || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    echo "Waiting for database... ($RETRY_COUNT/$MAX_RETRIES)"
    sleep 10
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "Database failed to become ready in time"
    exit 1
fi

echo "Database is ready!"
sleep 5  # Extra wait to ensure PostgreSQL is fully up

# Verify database connection
echo "Verifying database connection..."
kubectl exec deployment/backend -n ticketboard -- npx prisma db version

echo "Database connection successful!"