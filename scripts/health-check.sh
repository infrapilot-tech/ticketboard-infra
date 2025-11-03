#!/bin/bash

echo "🏥 Health check for TicketBoard..."

echo "📊 Namespace status:"
kubectl get all -n ticketboard

echo "🔍 Pods details:"
kubectl describe pods -n ticketboard

echo "📝 Recent events:"
kubectl get events -n ticketboard --sort-by=.metadata.creationTimestamp

# Verificar Grafana en el puerto correcto
echo "Checking Grafana..."
kubectl run -i --rm --restart=Never health-check --image=curlimages/curl \
  -n ticketboard --command -- curl -s http://grafana-service:3050/api/health && echo "✅ Grafana OK"