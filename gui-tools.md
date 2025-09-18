# GUI Tools for Kubernetes Management

Since you prefer GUI for easier understanding, here are the best tools:

## 1. K9s (Terminal UI) - RECOMMENDED
```bash
# Install k9s
curl -sS https://webinstall.dev/k9s | bash

# Use it
k9s
```
**Features:**
- Real-time cluster view
- Easy pod logs, exec, port-forward
- Resource editing
- Very intuitive

## 2. Lens (Desktop App) - BEST GUI
```bash
# Download from: https://k8slens.dev/
# Install and connect to your EKS cluster
```
**Features:**
- Full cluster management
- Visual pod/service relationships
- Built-in terminal
- Metrics and monitoring

## 3. Kubernetes Dashboard
```bash
# Install dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

# Create admin user
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Get token
kubectl -n kubernetes-dashboard create token admin-user

# Access dashboard
kubectl proxy
# Open: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

## 4. Octant (Web UI)
```bash
# Install octant
curl -L https://github.com/vmware-tanzu/octant/releases/download/v0.25.1/octant_0.25.1_Linux-64bit.tar.gz | tar xz
sudo mv octant_0.25.1_Linux-64bit/octant /usr/local/bin/

# Run
octant
# Open: http://localhost:7777
```

## Quick Commands for Your Setup

```bash
# View your authentication system
kubectl get all -n auth-system

# Check ingress status
kubectl get ingress -n auth-system

# View pod logs
kubectl logs -f deployment/authelia -n auth-system

# Port forward to access locally
kubectl port-forward svc/authelia-service 9091:9091 -n auth-system
# Access: http://localhost:9091

# Edit configurations
kubectl edit configmap authelia-config -n auth-system
```

## Recommended Workflow

1. **Use Lens** for overall cluster management
2. **Use k9s** for quick troubleshooting
3. **Use kubectl** for deployments and updates

This gives you the best of both worlds - GUI for understanding and CLI for automation! 🎯