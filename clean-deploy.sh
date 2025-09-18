#!/bin/bash

# Clean EKS Authentication System Deployment (Cloud Native)

echo "🚀 Deploying Cloud Native Authentication System to EKS..."

# Create namespace
echo "📁 Creating namespace..."
kubectl create namespace auth-system --dry-run=client -o yaml | kubectl apply -f -

# Apply secrets and configmaps
echo "🔐 Applying secrets and configurations..."
kubectl apply -f k8s-manifests/secrets/auth-secrets.yaml
kubectl apply -f k8s-manifests/configmaps/authelia-config.yaml

# Apply storage (only for auth services)
echo "💾 Creating persistent volumes..."
kubectl apply -f k8s-manifests/pvc/auth-storage.yaml

# Apply services (only for auth services)
echo "🌐 Creating services..."
kubectl apply -f k8s-manifests/services/services.yaml

# Apply deployments (only auth services)
echo "🚢 Deploying applications..."
kubectl apply -f k8s-manifests/deployments/authelia.yaml
kubectl apply -f k8s-manifests/deployments/lldap.yaml

# Wait for deployments to be ready
echo "⏳ Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/authelia -n auth-system
kubectl wait --for=condition=available --timeout=300s deployment/lldap -n auth-system

# Apply ingress
echo "🌍 Creating ingress resources..."
kubectl apply -f k8s-manifests/ingress/authelia-ingress.yaml
kubectl apply -f k8s-manifests/ingress/lldap-ingress.yaml

echo "✅ Cloud Native Deployment Complete!"
echo ""
echo "📋 Access URLs:"
echo "   Authelia: https://authelia.yasirbhati.site"
echo "   LLDAP Admin: https://ldap-php.yasirbhati.site"
echo ""
echo "🔑 Default LLDAP Credentials:"
echo "   Username: admin"
echo "   Password: super_strong_ldap_password"
echo ""
echo "📊 Check status:"
echo "   kubectl get pods -n auth-system"
echo "   kubectl get ingress -n auth-system"
echo ""
echo "🌐 Get NGINX Ingress LoadBalancer IP:"
echo "   kubectl get svc -n ingress-nginx"