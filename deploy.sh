#!/bin/bash

# EKS Authentication System Deployment Script

echo "🚀 Deploying Authentication System to EKS..."

# Create namespace
echo "📁 Creating namespace..."
kubectl create namespace auth-system --dry-run=client -o yaml | kubectl apply -f -

# Apply secrets and configmaps
echo "🔐 Applying secrets and configurations..."
kubectl apply -f k8s-manifests/secrets/
kubectl apply -f k8s-manifests/configmaps/

# Apply storage
echo "💾 Creating persistent volumes..."
kubectl apply -f k8s-manifests/pvc/

# Apply services
echo "🌐 Creating services..."
kubectl apply -f k8s-manifests/services/

# Apply deployments
echo "🚢 Deploying applications..."
kubectl apply -f k8s-manifests/deployments/

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/authelia -n auth-system
kubectl wait --for=condition=available --timeout=300s deployment/lldap -n auth-system

# Apply ingress
echo "🌍 Creating ingress resources..."
kubectl apply -f k8s-manifests/ingress/

echo "✅ Deployment complete!"
echo ""
echo "📋 Access URLs:"
echo "   Authelia: https://auth.yasirbhati.site"
echo "   LLDAP Admin: https://ldap.yasirbhati.site"
echo "   NGINX Proxy Manager: https://proxy.yasirbhati.site"
echo ""
echo "🔑 Default Credentials:"
echo "   LLDAP: admin / super_strong_ldap_password"
echo "   NGINX Proxy: admin@example.com / changeme"
echo ""
echo "📊 Check status:"
echo "   kubectl get pods -n auth-system"
echo "   kubectl get ingress -n auth-system"