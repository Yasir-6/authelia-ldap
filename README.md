# EKS Authelia + LLDAP Authentication Setup

Cloud-native authentication system for EKS using Authelia and LLDAP.

## Quick Start

1. **Install prerequisites:**
   ```bash
   # NGINX Ingress Controller
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml
   
   # cert-manager
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
   
   # SSL issuer
   kubectl apply -f cert-manager-setup.yaml
   ```

2. **Deploy authentication system:**
   ```bash
   chmod +x clean-deploy.sh
   ./clean-deploy.sh
   ```

3. **DNS Setup:**
   ```bash
   # Get LoadBalancer IP
   kubectl get svc ingress-nginx-controller -n ingress-nginx
   
   # Point these domains to the IP:
   # authelia.yasirbhati.site
   # ldap-php.yasirbhati.site
   ```

## Access URLs
- **Authelia**: https://authelia.yasirbhati.site
- **LLDAP Admin**: https://ldap-php.yasirbhati.site

## Default Credentials
- **LLDAP**: admin / super_strong_ldap_password

## Protect Your Apps
Use `k8s-manifests/ingress/protected-app-example.yaml` as template.