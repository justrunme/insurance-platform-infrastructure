# Insurance Platform Deployment Guide

This guide provides step-by-step instructions for deploying the insurance platform infrastructure and applications.

## Prerequisites

### Software Requirements
- **Terraform** >= 1.0
- **kubectl** >= 1.28
- **Docker** >= 20.10
- **AWS CLI** >= 2.0
- **Helm** >= 3.0
- **Git**

### AWS Account Setup
1. Create an AWS account with administrative access
2. Configure AWS CLI with appropriate credentials
3. Create an S3 bucket for Terraform state (production)
4. Create ECR repositories for container images

### Local Development Prerequisites
- **Minikube** >= 1.30 (for local testing)
- **Go** >= 1.21 (for claims-api development)
- **Node.js** >= 18 (for client-portal development)

## Deployment Options

### Option 1: Local Development with Minikube

#### 1. Start Minikube
```bash
minikube start --driver=docker --memory=8192 --cpus=4
minikube addons enable ingress
```

#### 2. Deploy Infrastructure (Local)
```bash
# Navigate to dev environment
cd terraform/environments/dev

# Initialize Terraform
terraform init

# Review and apply infrastructure
terraform plan
terraform apply
```

#### 3. Install ArgoCD
```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD to be ready
kubectl wait --for=condition=available --timeout=600s deployment/argocd-server -n argocd

# Get ArgoCD admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### 4. Access ArgoCD UI
```bash
# Port forward ArgoCD server
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Open browser: https://localhost:8080
# Username: admin
# Password: (from step 3)
```

#### 5. Deploy Applications
```bash
# Apply ArgoCD applications
kubectl apply -f argo/applications/

# Monitor deployment status
kubectl get applications -n argocd
```

### Option 2: AWS Production Deployment

#### 1. Configure AWS Backend
```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://insurance-platform-terraform-state

# Update backend configuration in terraform/environments/prod/main.tf
```

#### 2. Deploy Infrastructure
```bash
cd terraform/environments/prod

# Configure production variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with production values

terraform init
terraform plan
terraform apply
```

#### 3. Configure kubectl
```bash
aws eks update-kubeconfig --region us-west-2 --name insurance-platform-prod
```

#### 4. Install Monitoring Stack
```bash
# Add Prometheus Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring

# Install Prometheus and Grafana
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values monitoring/helm/prometheus-grafana-values.yaml
```

#### 5. Install Vault
```bash
# Add HashiCorp Helm repository
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update

# Create vault namespace
kubectl create namespace vault

# Install Vault
helm install vault hashicorp/vault \
  --namespace vault \
  --set='server.ha.enabled=true' \
  --set='server.ha.replicas=3'
```

## Application Deployment

### Building and Pushing Container Images

#### Claims API (Go)
```bash
cd apps/claims-api

# Build Docker image
docker build -t insurance-platform/claims-api:latest .

# Tag for ECR (replace with your ECR URL)
docker tag insurance-platform/claims-api:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/insurance-platform/claims-api:latest

# Push to ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-west-2.amazonaws.com
docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/insurance-platform/claims-api:latest
```

#### Client Portal (React)
```bash
cd apps/client-portal

# Build Docker image
docker build -t insurance-platform/client-portal:latest .

# Tag and push to ECR
docker tag insurance-platform/client-portal:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/insurance-platform/client-portal:latest
docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/insurance-platform/client-portal:latest
```

### GitOps Deployment with ArgoCD

1. **Configure Git Repository**
   - Update repository URL in ArgoCD applications
   - Ensure proper Git authentication

2. **Deploy Applications**
   ```bash
   # Apply ArgoCD project and applications
   kubectl apply -f argo/applications/client-portal.yaml
   
   # Monitor deployment
   argocd app sync insurance-platform
   argocd app get insurance-platform
   ```

## Security Configuration

### 1. Secrets Management
```bash
# Create database secrets
kubectl create secret generic database-config \
  --from-literal=host=insurance-platform-dev-postgres.xxxxx.us-west-2.rds.amazonaws.com \
  --from-literal=port=5432 \
  --from-literal=database=insurance_platform \
  --from-literal=username=postgres \
  --from-literal=password=secure-password \
  -n insurance-platform
```

### 2. Network Policies
Network policies are automatically applied via Kubernetes manifests to restrict inter-pod communication.

### 3. RBAC Configuration
```bash
# Create service accounts with minimal permissions
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: claims-api
  namespace: insurance-platform
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: insurance-platform
  name: claims-api-role
rules:
- apiGroups: [""]
  resources: ["secrets", "configmaps"]
  verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: claims-api-binding
  namespace: insurance-platform
subjects:
- kind: ServiceAccount
  name: claims-api
  namespace: insurance-platform
roleRef:
  kind: Role
  name: claims-api-role
  apiGroup: rbac.authorization.k8s.io
EOF
```

## Monitoring and Observability

### 1. Access Grafana
```bash
# Port forward Grafana
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring

# Default credentials: admin/admin
# Browser: http://localhost:3000
```

### 2. Access Prometheus
```bash
# Port forward Prometheus
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring

# Browser: http://localhost:9090
```

### 3. Custom Dashboards
Pre-configured dashboards for the insurance platform:
- Application Performance Monitoring
- Infrastructure Health
- Business Metrics (Claims processing)
- Security Metrics

## Troubleshooting

### Common Issues

#### 1. EKS Cluster Access
```bash
# Update kubeconfig
aws eks update-kubeconfig --region us-west-2 --name insurance-platform-dev

# Verify access
kubectl get nodes
```

#### 2. ArgoCD Sync Issues
```bash
# Check application status
kubectl get applications -n argocd

# View application details
kubectl describe application claims-api -n argocd

# Force sync
argocd app sync claims-api --force
```

#### 3. Pod Startup Issues
```bash
# Check pod logs
kubectl logs -f deployment/claims-api -n insurance-platform

# Check pod events
kubectl describe pod <pod-name> -n insurance-platform

# Check resource usage
kubectl top pods -n insurance-platform
```

#### 4. Database Connection Issues
```bash
# Test database connectivity
kubectl run postgres-client --rm -i --tty --image postgres -- psql -h <db-host> -U postgres

# Check database secrets
kubectl get secret database-config -n insurance-platform -o yaml
```

### Health Checks

#### Application Health
```bash
# Check application health endpoints
kubectl get pods -n insurance-platform
kubectl port-forward svc/claims-api 8080:80 -n insurance-platform

# Test endpoints
curl http://localhost:8080/health
curl http://localhost:8080/ready
```

#### Infrastructure Health
```bash
# Check node status
kubectl get nodes

# Check cluster info
kubectl cluster-info

# Check system pods
kubectl get pods -n kube-system
```

## Backup and Recovery

### 1. Database Backups
RDS automated backups are configured with 7-day retention.

### 2. Kubernetes State
```bash
# Backup Kubernetes resources
kubectl get all --all-namespaces -o yaml > cluster-backup.yaml

# Backup secrets (encrypted)
kubectl get secrets --all-namespaces -o yaml > secrets-backup.yaml
```

### 3. Application Data
Application data in S3 is versioned and backed up across multiple AZs.

## Scaling

### 1. Horizontal Pod Autoscaler
```bash
# Create HPA for claims-api
kubectl autoscale deployment claims-api --cpu-percent=70 --min=2 --max=10 -n insurance-platform

# Check HPA status
kubectl get hpa -n insurance-platform
```

### 2. Cluster Autoscaler
EKS cluster is configured with managed node groups that automatically scale based on resource demands.

## Security Best Practices

1. **Container Security**
   - Images are scanned with Trivy
   - Run as non-root user
   - Read-only root filesystem
   - Security contexts applied

2. **Network Security**
   - Network policies restrict traffic
   - TLS encryption for all communications
   - Private subnets for sensitive components

3. **Access Control**
   - RBAC for fine-grained permissions
   - Service accounts with minimal privileges
   - Secrets management with Vault

4. **Compliance**
   - Audit logging enabled
   - CloudTrail for API calls
   - VPC flow logs for network monitoring

For additional support, please refer to the project documentation or create an issue in the repository. 