# EKS Authentication Setup

## Prerequisites
1. EKS cluster with NGINX Ingress Controller installed
2. kubectl configured for your EKS cluster
3. Domain `yasirbhati.site` pointing to your NGINX Ingress LoadBalancer
4. cert-manager installed for SSL certificates

## Deployment Steps

1. **Create namespace:**
   ```bash
   kubectl create namespace auth-system
   ```

2. **Apply configurations in order:**
   ```bash
   # Secrets and ConfigMaps
   kubectl apply -f k8s-manifests/secrets/
   kubectl apply -f k8s-manifests/configmaps/
   
   # Storage
   kubectl apply -f k8s-manifests/pvc/
   
   # Services
   kubectl apply -f k8s-manifests/services/
   
   # Deployments
   kubectl apply -f k8s-manifests/deployments/
   
   # Ingress (after deployments are ready)
   kubectl apply -f k8s-manifests/ingress/
   ```

3. **Verify deployment:**
   ```bash
   kubectl get pods -n auth-system
   kubectl get ingress -n auth-system
   ```

## Access URLs
- Authelia: https://auth.yasirbhati.site
- LLDAP Admin: https://ldap.yasirbhati.site
- NGINX Proxy Manager: https://proxy.yasirbhati.site

## Default Credentials
- LLDAP Admin: admin / super_strong_ldap_password
- NGINX Proxy Manager: admin@example.com / changeme

## Important Notes
- Change all default passwords in secrets before production use
- Update JWT secrets with your own random values
- Ensure your domain DNS points to the NGINX Ingress LoadBalancer IP