#!/bin/bash

echo "=== Ticketboard Health Check ==="

# Check pods
echo "1. Checking pods..."
kubectl get pods -n ticketboard

# Check services
echo -e "\n2. Checking services..."
kubectl get services -n ticketboard

# Check ingress
echo -e "\n3. Checking ingress..."
kubectl get ingress -n ticketboard

# Check backend health
echo -e "\n4. Checking backend health..."
BACKEND_POD=$(kubectl get pods -n ticketboard -l app=backend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -n "$BACKEND_POD" ]; then
    if kubectl exec -n ticketboard $BACKEND_POD -- curl -s http://localhost:3000/api/health; then
        echo "Backend health: OK"
    else
        echo "Backend health: FAILED"
    fi
else
    echo "Backend pod not found"
fi

# Check frontend health
echo -e "\n5. Checking frontend health..."
FRONTEND_POD=$(kubectl get pods -n ticketboard -l app=frontend -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -n "$FRONTEND_POD" ]; then
    if kubectl exec -n ticketboard $FRONTEND_POD -- curl -s http://localhost/health; then
        echo "Frontend health: OK"
    else
        echo "Frontend health: FAILED"
    fi
else
    echo "Frontend pod not found"
fi

# Check database connection
echo -e "\n6. Checking database connection..."
if [ -n "$BACKEND_POD" ]; then
    if kubectl exec -n ticketboard $BACKEND_POD -- npx prisma db version; then
        echo "Database connection: OK"
    else
        echo "Database connection: FAILED"
    fi
else
    echo "Backend pod not found - skipping database check"
fi

echo -e "\n=== Health Check Complete ==="