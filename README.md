# Insurance Platform Infrastructure

## Overview

This project implements a production-ready Infrastructure-as-Code (IaC) and GitOps solution for a secure insurance platform. The infrastructure supports claims processing and client portal services with enterprise-grade security, monitoring, and compliance capabilities.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Portal │    │   Claims API    │    │   Monitoring    │
│   (React)       │    │   (Go)          │    │   (Prometheus)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
┌─────────────────────────────────┼─────────────────────────────────┐
│                    Kubernetes Cluster (EKS/Minikube)              │
├─────────────────────────────────┼─────────────────────────────────┤
│  ArgoCD │ Vault │ OPA │ Trivy │ Ingress │ Service Mesh             │
└─────────────────────────────────┼─────────────────────────────────┘
                                  │
┌─────────────────────────────────┼─────────────────────────────────┐
│                        AWS Infrastructure                         │
│  VPC │ EKS │ RDS │ S3 │ IAM │ CloudTrail │ Security Groups       │
└─────────────────────────────────────────────────────────────────┘
```

## Key Features

### 🏗️ Infrastructure as Code
- **Terraform modules** for AWS resources
- **Multi-environment** support (dev/staging/prod)
- **State management** with S3 backend
- **Security** by design with least privilege IAM

### 🚀 GitOps Delivery
- **ArgoCD** for continuous deployment
- **Automated** application sync from Git
- **Rollback** capabilities for failed deployments
- **Progressive** delivery strategies

### 🔒 Enterprise Security
- **HashiCorp Vault** for secrets management
- **Trivy** for container image scanning
- **OPA Gatekeeper** for policy enforcement
- **GDPR & ISO 27001** compliance ready

### 📊 Observability
- **Prometheus** metrics collection
- **Grafana** dashboards and visualization
- **Loki** for log aggregation
- **Alertmanager** for incident response

## Technology Stack

| Category | Technologies |
|----------|-------------|
| **IaC** | Terraform, Terragrunt |
| **GitOps** | ArgoCD, Kubernetes |
| **Container Platform** | Docker, Kubernetes (EKS/Minikube) |
| **CI/CD** | GitHub Actions |
| **Security** | Vault, Trivy, OPA Gatekeeper |
| **Monitoring** | Prometheus, Grafana, Loki |
| **Applications** | Go (API), React (Frontend) |

## Quick Start

### Prerequisites
- Terraform >= 1.0
- kubectl
- Docker
- AWS CLI (for AWS deployment)
- Minikube (for local development)

### Local Development Setup

1. **Start Minikube cluster:**
```bash
minikube start --driver=docker --memory=4096 --cpus=2
```

2. **Deploy infrastructure:**
```bash
cd terraform/environments/dev
terraform init
terraform plan
terraform apply
```

3. **Install ArgoCD:**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

4. **Deploy applications:**
```bash
kubectl apply -f argo/applications/
```

### Production Deployment

For production AWS deployment, see [docs/deployment-guide.md](docs/deployment-guide.md)

## Project Structure

```
security-infrastructure/
├── terraform/                 # Infrastructure as Code
│   ├── modules/               # Reusable Terraform modules
│   │   ├── eks/              # EKS cluster module
│   │   ├── vpc/              # VPC networking module
│   │   └── security/         # Security groups & IAM
│   └── environments/         # Environment configurations
│       ├── dev/              # Development environment
│       └── prod/             # Production environment
├── argo/                     # ArgoCD configurations
│   └── applications/         # Application manifests
├── apps/                     # Application source code
│   ├── claims-api/           # Claims processing API (Go)
│   └── client-portal/        # Customer portal (React)
├── monitoring/               # Monitoring configurations
│   └── helm/                 # Helm charts for monitoring stack
├── .github/workflows/        # CI/CD pipelines
└── docs/                     # Documentation
```

## Security & Compliance

This platform implements security best practices for the insurance industry:

- **Data Encryption**: At rest and in transit
- **Access Control**: RBAC with least privilege
- **Audit Logging**: Complete audit trail with CloudTrail
- **Vulnerability Scanning**: Automated with Trivy
- **Policy Enforcement**: OPA Gatekeeper policies
- **Secrets Management**: HashiCorp Vault integration

## Monitoring & Alerting

Comprehensive observability stack:

- **Application Metrics**: Custom business metrics
- **Infrastructure Metrics**: Node and cluster health
- **Log Aggregation**: Centralized logging with Loki
- **Alerting**: Proactive monitoring with Alertmanager
- **Dashboards**: Pre-built Grafana dashboards

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and security scans
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions, please create an issue in this repository.

---

**Note**: This is a demonstration project showcasing DevOps best practices for insurance industry applications. Adapt configurations according to your specific security and compliance requirements. 