#!/bin/bash

# Navigate to eks-auth-setup directory
cd "$(dirname "$0")"

# Initialize git repo
git init

# Create .gitignore to exclude sensitive files
cat > .gitignore << EOF
# Exclude sensitive files
*.log
.DS_Store
EOF

# Add all files
git add .

# Initial commit
git commit -m "Initial commit: EKS Authelia + LLDAP authentication setup"

# Set main branch
git branch -M main

# Add remote origin
git remote add origin https://github.com/Yasir-6/authelia-ldap.git

# Push to GitHub
git push -u origin main

echo "✅ Successfully pushed to GitHub!"
echo "🌐 Repository: https://github.com/Yasir-6/authelia-ldap"