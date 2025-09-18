# EKS Cloud Native Authentication Setup

## Why This Approach is Better for EKS

✅ **Cloud Native**: Uses Kubernetes ingress controllers  
✅ **Cost Effective**: Single LoadBalancer for all services  
✅ **Scalable**: Auto-scales with your EKS cluster  
✅ **GitOps Ready**: Everything defined as code  
✅ **AWS Integration**: Works with ALB, NLB, cert-manager, external-dns  

## Prerequisites

1. **EKS cluster with NGINX Ingress Controller:**
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/aws/deploy.yaml
   ```

2. **cert-manager for SSL:**
   ```bash
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
   ```

3. **Update cert-manager-setup.yaml with your email, then:**
   ```bash
   kubectl apply -f cert-manager-setup.yaml
   ```

## Quick Deployment

```bash
chmod +x clean-deploy.sh
./clean-deploy.sh
```

## DNS Setup

1. **Get NGINX Ingress LoadBalancer IP:**
   ```bash
   kubectl get svc ingress-nginx-controller -n ingress-nginx
   ```

2. **Point these domains to the LoadBalancer IP:**
   - `auth.yasirbhati.site`
   - `ldap.yasirbhati.site`
   - `*.yasirbhati.site` (for future apps)

## Access URLs
- **Authelia**: https://auth.yasirbhati.site
- **LLDAP Admin**: https://ldap.yasirbhati.site

## Protect Your Applications

Use this ingress template for any app you want to protect:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-protected-app
  namespace: my-app-namespace
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    # Authelia protection
    nginx.ingress.kubernetes.io/auth-url: "http://authelia-service.auth-system.svc.cluster.local:9091/api/verify"
    nginx.ingress.kubernetes.io/auth-signin: "https://auth.yasirbhati.site/?rd=$escaped_request_uri"
    nginx.ingress.kubernetes.io/auth-response-headers: "Remote-User,Remote-Name,Remote-Email,Remote-Groups"
spec:
  tls:
  - hosts:
    - myapp.yasirbhati.site
    secretName: myapp-tls
  rules:
  - host: myapp.yasirbhati.site
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

## Management

- **View pods**: `kubectl get pods -n auth-system`
- **View ingress**: `kubectl get ingress -n auth-system`
- **View logs**: `kubectl logs -f deployment/authelia -n auth-system`
- **Scale**: `kubectl scale deployment authelia --replicas=2 -n auth-system`

## Benefits Over NGINX Proxy Manager

| Feature | NGINX Proxy Manager | Kubernetes Ingress |
|---------|-------------------|-------------------|
| Cost | Extra LoadBalancer | Single LoadBalancer |
| Scaling | Manual | Auto with cluster |
| Backup | Manual | GitOps |
| Integration | Limited | Full AWS integration |
| Management | GUI only | CLI + GUI (k9s, lens) |

You're absolutely right - this is the proper EKS way! 🎯