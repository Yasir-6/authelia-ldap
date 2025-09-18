# NGINX Proxy Manager Setup Guide

## Access Your Proxy Manager
- URL: https://proxy.yasirbhati.site
- Default Login: admin@example.com / changeme

## Initial Setup Steps

1. **Login and Change Password**
   - Login with default credentials
   - Go to Users → Admin User → Edit
   - Change email and password

2. **Point Your Domain to LoadBalancer**
   ```bash
   # Get LoadBalancer IP
   kubectl get svc nginx-proxy-manager-lb -n auth-system
   ```
   - Point `*.yasirbhati.site` to this IP in your DNS

3. **Create Proxy Hosts**

### For Authelia:
- Domain: `auth.yasirbhati.site`
- Forward to: `authelia-service.auth-system.svc.cluster.local:9091`
- SSL: Request new certificate
- Advanced → Custom Nginx Config:
```nginx
location /api/verify {
    internal;
    proxy_pass http://authelia-service.auth-system.svc.cluster.local:9091;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header X-Original-Method $request_method;
    proxy_set_header X-Forwarded-Method $request_method;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Forwarded-For $remote_addr;
}
```

### For LLDAP:
- Domain: `ldap.yasirbhati.site`
- Forward to: `lldap-service.auth-system.svc.cluster.local:17170`
- SSL: Request new certificate

### For Protected Apps:
- Domain: `app.yasirbhati.site`
- Forward to: `your-app-service.namespace.svc.cluster.local:port`
- SSL: Request new certificate
- Advanced → Custom Nginx Config:
```nginx
auth_request /api/verify;
auth_request_set $user $upstream_http_remote_user;
auth_request_set $groups $upstream_http_remote_groups;
auth_request_set $name $upstream_http_remote_name;
auth_request_set $email $upstream_http_remote_email;

proxy_set_header Remote-User $user;
proxy_set_header Remote-Groups $groups;
proxy_set_header Remote-Name $name;
proxy_set_header Remote-Email $email;

error_page 401 =302 https://auth.yasirbhati.site/?rd=$escaped_request_uri;

location /api/verify {
    internal;
    proxy_pass http://authelia-service.auth-system.svc.cluster.local:9091;
    proxy_pass_request_body off;
    proxy_set_header Content-Length "";
    proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
    proxy_set_header X-Original-Method $request_method;
    proxy_set_header X-Forwarded-Method $request_method;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $http_host;
    proxy_set_header X-Forwarded-Uri $request_uri;
    proxy_set_header X-Forwarded-For $remote_addr;
}
```

## Alternative: Use Kubernetes Ingress
If you prefer Kubernetes ingress over NGINX Proxy Manager, you can:
1. Delete the nginx-proxy-manager deployment
2. Use the ingress files in the ingress/ folder
3. Point your domain to the NGINX Ingress Controller LoadBalancer instead