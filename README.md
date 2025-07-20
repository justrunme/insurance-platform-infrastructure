# Insurance Platform Infrastructure

This is a realistic DevOps project demonstrating secure insurance platform infrastructure with modern cloud-native technologies.

## 🏗️ Architecture

### Infrastructure Components
- **Infrastructure as Code**: Terraform modules for VPC, EKS, RDS
- **Container Orchestration**: AWS EKS with Kubernetes
- **GitOps Deployment**: ArgoCD for automated deployments
- **Service Mesh**: Istio for secure service communication
- **Monitoring Stack**: Prometheus, Grafana, Loki, Alertmanager
- **Security**: OPA Gatekeeper, Trivy scanning, Vault secrets management

### Application Services
- **Claims API**: Go microservice with Gin framework
- **Client Portal**: React frontend with Material-UI
- **Database**: PostgreSQL on AWS RDS with encryption
- **Container Registry**: AWS ECR with image scanning

### Security & Compliance
- **Security Scanning**: Trivy for vulnerabilities, dependency checks
- **Secrets Management**: HashiCorp Vault integration
- **Network Security**: VPC, security groups, network policies
- **Compliance**: GDPR, ISO 27001, SOC 2 ready
- **RBAC**: Kubernetes role-based access control

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- kubectl and helm
- Terraform >= 1.6
- Go >= 1.21
- Node.js >= 18
- Minikube (for local testing)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd insurance-platform-infrastructure
   ```

2. **Install development tools**
   ```bash
   make setup
   ```

3. **Run tests and linting**
   ```bash
   make test
   make lint
   ```

4. **Build Docker images**
   ```bash
   make docker-build
   ```

5. **Deploy to local Minikube**
   ```bash
   make k8s-deploy-local
   ```

### AWS Deployment Setup

To enable AWS deployment in GitHub Actions, you need to configure the following:

1. **Set Repository Variables**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Under "Variables" tab, add:
     - `AWS_ENABLED`: Set to `true` to enable AWS deployment
     - `AWS_REGION`: Your preferred AWS region (e.g., `us-west-2`)

2. **Set Repository Secrets**
   - Under "Secrets" tab, add:
     - `AWS_ACCESS_KEY_ID`: Your AWS access key
     - `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
     - `SLACK_WEBHOOK_URL`: For deployment notifications (optional)

3. **AWS IAM Permissions**
   Your AWS user/role needs permissions for:
   - EKS cluster management
   - ECR repository access
   - VPC and networking
   - RDS database management
   - S3 for Terraform state (if using remote backend)

4. **Terraform Backend (Optional)**
   ```hcl
   terraform {
     backend "s3" {
       bucket = "your-terraform-state-bucket"
       key    = "insurance-platform/terraform.tfstate"
       region = "us-west-2"
     }
   }
   ```

### Manual Deployment Commands

**Infrastructure Deployment:**
```bash
# Deploy development environment
git commit -m "Deploy dev infrastructure [deploy-infra]"
git push

# Deploy production (manual trigger required)
# Go to Actions → Deploy Production → Run workflow
```

**Application Deployment:**
```bash
# Automatic deployment on main branch push
git push origin main
```

## 🛠️ Development Workflow

### Available Make Commands
```bash
make help              # Show all available commands
make setup             # Install development dependencies
make test              # Run all tests
make lint              # Run linting and formatting
make docker-build      # Build Docker images
make docker-run        # Run services with Docker Compose
make terraform-init    # Initialize Terraform
make terraform-plan    # Plan infrastructure changes
make k8s-deploy-local  # Deploy to Minikube
make security-scan     # Run security scans
make pre-commit-install # Install pre-commit hooks
```

### CI/CD Pipeline

The GitHub Actions workflow includes:

**Without AWS (Default):**
- Code quality checks (linting, formatting)
- Security scanning with Trivy
- Unit tests (Go, React)
- Terraform validation
- Local Docker builds

**With AWS (when `AWS_ENABLED=true`):**
- All of the above, plus:
- Build and push to AWS ECR
- Deploy to EKS development environment
- Infrastructure deployment with Terraform
- Production deployment (manual trigger)

## 📁 Project Structure

```
├── apps/
│   ├── claims-api/          # Go microservice
│   └── client-portal/       # React frontend
├── terraform/
│   ├── modules/             # Reusable Terraform modules
│   └── environments/        # Environment-specific configs
├── kubernetes/
│   ├── base/                # Base Kubernetes manifests
│   └── overlays/            # Kustomize overlays
├── .github/workflows/       # CI/CD pipelines
├── Makefile                 # Development commands
└── docker-compose.yml       # Local development stack
```

## 🔒 Security Features

- **Container Security**: Trivy scanning, non-root containers
- **Network Security**: VPC isolation, security groups
- **Secrets Management**: Vault integration, encrypted storage
- **Access Control**: RBAC, service accounts
- **Audit Logging**: CloudWatch, audit trails
- **Compliance**: GDPR, SOC 2, ISO 27001 ready

## 📊 Monitoring

- **Metrics**: Prometheus with custom business metrics
- **Logs**: Centralized logging with Loki
- **Tracing**: Distributed tracing with Jaeger
- **Dashboards**: Grafana with pre-built dashboards
- **Alerting**: Alertmanager with Slack integration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Run tests and linting
4. Submit a pull request

## 📄 License

This project is licensed under the MIT License. 