# 🏦 Insurance Platform Infrastructure

[![Terraform](https://img.shields.io/badge/Terraform-1.0%2B-623CE4?logo=terraform&logoColor=white)](https://terraform.io)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Go](https://img.shields.io/badge/Go-1.21-00ADD8?logo=go&logoColor=white)](https://golang.org)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)](https://reactjs.org)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EE7A00?logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> **Enterprise-grade DevOps platform for insurance companies** built with modern cloud-native technologies and security-first approach.

## 🎯 Overview

This project demonstrates a complete **production-ready infrastructure** for an insurance platform, featuring microservices architecture, Infrastructure as Code, GitOps delivery, comprehensive monitoring, and enterprise security practices.

### 🌟 Key Features

- 🏗️ **Infrastructure as Code** with Terraform modules
- 🚀 **GitOps Delivery** with ArgoCD
- 🐳 **Containerized Microservices** (Go + React)
- 📊 **Observability Stack** (Prometheus + Grafana)
- 🔒 **Security First** (RBAC, Network Policies, Encryption)
- ☁️ **Cloud Native** (Kubernetes, AWS EKS)
- 🔄 **CI/CD Pipelines** with GitHub Actions

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client Portal │    │   Claims API    │    │   Monitoring    │
│     (React)     │◄──►│      (Go)       │◄──►│ Prometheus +    │
│                 │    │                 │    │   Grafana       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
         ┌─────────────────────────────────────────┐
         │           Kubernetes Cluster            │
         │  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
         │  │  ArgoCD │  │   RBAC  │  │ Network │  │
         │  │ GitOps  │  │   Pod   │  │ Policies│  │
         │  │         │  │Security │  │         │  │
         │  └─────────┘  └─────────┘  └─────────┘  │
         └─────────────────────────────────────────┘
                                 │
         ┌─────────────────────────────────────────┐
         │             AWS Cloud                   │
         │  ┌─────────┐  ┌─────────┐  ┌─────────┐  │
         │  │   VPC   │  │   EKS   │  │   RDS   │  │
         │  │Multi-AZ │  │Cluster  │  │PostgreSQL│ │
         │  └─────────┘  └─────────┘  └─────────┘  │
         └─────────────────────────────────────────┘
```

## 📁 Project Structure

```
insurance-platform-infrastructure/
├── .github/workflows/          # CI/CD pipelines
├── apps/                      # Application services
│   ├── claims-api/           # Go microservice
│   └── client-portal/        # React frontend
├── argo/                     # ArgoCD applications
├── docs/                     # Documentation
├── monitoring/               # Prometheus & Grafana configs
└── terraform/               # Infrastructure as Code
    ├── modules/             # Reusable Terraform modules
    │   ├── vpc/            # VPC networking
    │   └── eks/            # Kubernetes cluster
    └── environments/        # Environment-specific configs
        ├── dev/            # Development environment
        └── prod/           # Production environment
```

## 🚀 Quick Start

### Prerequisites

- **Docker** & **Docker Compose**
- **Minikube** or **Kind** for local K8s
- **Terraform** >= 1.0
- **kubectl** & **helm**
- **AWS CLI** (for cloud deployment)

### 🏃‍♂️ Local Development

1. **Clone the repository**
```bash
git clone https://github.com/justrunme/insurance-platform-infrastructure.git
cd insurance-platform-infrastructure
```

2. **Start local Kubernetes cluster**
```bash
minikube start --memory=4096 --cpus=4
```

3. **Deploy the platform**
```bash
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Deploy applications
kubectl apply -f apps/claims-api/k8s-local.yaml
kubectl apply -f argo/applications/
```

4. **Access services**
```bash
# Claims API
kubectl port-forward svc/claims-api 8080:80 -n insurance-platform

# ArgoCD Dashboard
kubectl port-forward svc/argocd-server -n argocd 8081:443
```

### ☁️ Cloud Deployment (AWS)

1. **Configure AWS credentials**
```bash
aws configure
```

2. **Deploy infrastructure**
```bash
cd terraform/environments/prod
terraform init
terraform plan
terraform apply
```

3. **Configure kubectl**
```bash
aws eks update-kubeconfig --region us-west-2 --name insurance-platform-prod
```

## 🔧 Technology Stack

### **Infrastructure & DevOps**
- **Terraform** - Infrastructure as Code
- **AWS EKS** - Managed Kubernetes
- **ArgoCD** - GitOps continuous delivery
- **GitHub Actions** - CI/CD pipelines

### **Microservices**
- **Go** (Gin framework) - Claims API backend
- **React** (Material-UI) - Client portal frontend
- **PostgreSQL** - Primary database
- **Redis** - Caching layer

### **Observability**
- **Prometheus** - Metrics collection
- **Grafana** - Visualization & dashboards
- **Jaeger** - Distributed tracing
- **ELK Stack** - Centralized logging

### **Security**
- **Vault** - Secret management
- **OPA Gatekeeper** - Policy enforcement
- **Trivy** - Vulnerability scanning
- **Falco** - Runtime security

## 🛡️ Security Features

- **🔐 Zero Trust Architecture** with mTLS
- **🎭 RBAC** for fine-grained access control
- **🔒 End-to-end Encryption** (data in transit & at rest)
- **🛡️ Network Policies** for micro-segmentation
- **📋 Compliance** with GDPR, ISO 27001, SOC 2
- **🔍 Continuous Security Scanning** with Trivy
- **🚨 Runtime Security Monitoring** with Falco

## 📊 Monitoring & Observability

### **Metrics**
- Application performance metrics
- Infrastructure health monitoring
- Business KPIs tracking
- Custom SLI/SLO dashboards

### **Alerting**
- Proactive incident detection
- Multi-channel notifications (Slack, PagerDuty)
- Escalation policies
- Runbook automation

### **Logging**
- Centralized log aggregation
- Structured logging with correlation IDs
- Log-based alerting
- Compliance audit trails

## 🎯 Production Features

### **High Availability**
- Multi-AZ deployment across 3 availability zones
- Auto-scaling based on metrics
- Circuit breakers and retry policies
- Graceful degradation

### **Disaster Recovery**
- Automated backups with point-in-time recovery
- Cross-region replication
- Infrastructure recreation from code
- RTO < 4 hours, RPO < 1 hour

### **Performance**
- Horizontal pod autoscaling
- Cluster autoscaling
- Database read replicas
- CDN integration for static assets

## 📈 Cost Optimization

- **Right-sizing** with resource requests/limits
- **Spot instances** for non-critical workloads
- **Scheduled scaling** for predictable traffic
- **Resource tagging** for cost allocation
- **Monthly cost**: ~$300-800 for production environment

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Documentation

- [📖 Deployment Guide](docs/deployment-guide.md)
- [🔒 Security Compliance](docs/security-compliance.md)
- [🏗️ Architecture Decision Records](docs/adr/)
- [🐛 Troubleshooting Guide](docs/troubleshooting.md)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Kubernetes community for cloud-native best practices
- Terraform community for infrastructure automation
- CNCF projects for observability and security tools
- Insurance industry for compliance requirements

---

**⭐ Star this repository if it helped you build better DevOps infrastructure!**

**🔗 Connect with me:**
- [GitHub](https://github.com/justrunme)
- [LinkedIn](https://linkedin.com/in/yourprofile)

---

> *"Infrastructure as Code + GitOps + Cloud Native = Future of DevOps"* 