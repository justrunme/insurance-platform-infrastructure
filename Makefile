# Insurance Platform Infrastructure Makefile
# Usage: make <target>

.PHONY: help setup clean test fmt lint docker-build terraform-init terraform-plan terraform-apply

# Default target
help: ## Show this help message
	@echo "Insurance Platform Infrastructure - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Examples:"
	@echo "  make setup          # Set up development environment"
	@echo "  make test           # Run all tests"
	@echo "  make fmt            # Format all code"
	@echo "  make docker-build   # Build all Docker images"

# Development setup
setup: ## Set up development environment
	@echo "🔧 Setting up development environment..."
	@if command -v pip >/dev/null 2>&1; then \
		pip install pre-commit; \
		pre-commit install; \
		echo "✅ Pre-commit hooks installed"; \
	else \
		echo "⚠️  pip not found, skipping pre-commit setup"; \
	fi
	@if [ -d "apps/claims-api" ]; then \
		cd apps/claims-api && go mod tidy; \
		echo "✅ Go dependencies updated"; \
	fi
	@if [ -d "apps/client-portal" ]; then \
		cd apps/client-portal && npm install; \
		echo "✅ Node.js dependencies updated"; \
	fi
	@echo "🚀 Development environment ready!"

# Cleanup
clean: ## Clean build artifacts and caches
	@echo "🧹 Cleaning up..."
	@find . -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.tfplan" -delete 2>/dev/null || true
	@find . -name "coverage" -type d -exec rm -rf {} + 2>/dev/null || true
	@docker system prune -f 2>/dev/null || true
	@echo "✅ Cleanup completed!"

# Testing
test: test-go test-react ## Run all tests
	@echo "✅ All tests completed!"

test-go: ## Run Go tests
	@echo "🧪 Running Go tests..."
	@if [ -d "apps/claims-api" ]; then \
		cd apps/claims-api && go test -v ./...; \
	else \
		echo "⚠️  claims-api directory not found"; \
	fi

test-react: ## Run React tests
	@echo "🧪 Running React tests..."
	@if [ -d "apps/client-portal" ]; then \
		cd apps/client-portal && npm test -- --coverage --watchAll=false; \
	else \
		echo "⚠️  client-portal directory not found"; \
	fi

# Code formatting
fmt: fmt-terraform fmt-go fmt-react ## Format all code
	@echo "✅ Code formatting completed!"

fmt-terraform: ## Format Terraform code
	@echo "🎨 Formatting Terraform code..."
	@terraform fmt -recursive terraform/ || echo "⚠️  Terraform not installed"

fmt-go: ## Format Go code
	@echo "🎨 Formatting Go code..."
	@if [ -d "apps/claims-api" ]; then \
		cd apps/claims-api && go fmt ./...; \
	else \
		echo "⚠️  claims-api directory not found"; \
	fi

fmt-react: ## Format React code
	@echo "🎨 Formatting React code..."
	@if [ -d "apps/client-portal" ]; then \
		cd apps/client-portal && npm run format 2>/dev/null || echo "Format script not available"; \
	else \
		echo "⚠️  client-portal directory not found"; \
	fi

# Linting
lint: lint-terraform lint-go lint-react ## Run all linters
	@echo "✅ Linting completed!"

lint-terraform: ## Lint Terraform code
	@echo "🔍 Linting Terraform code..."
	@terraform fmt -check -recursive terraform/ || echo "⚠️  Terraform formatting issues found"

lint-go: ## Lint Go code
	@echo "🔍 Linting Go code..."
	@if [ -d "apps/claims-api" ]; then \
		cd apps/claims-api && go vet ./...; \
	else \
		echo "⚠️  claims-api directory not found"; \
	fi

lint-react: ## Lint React code
	@echo "🔍 Linting React code..."
	@if [ -d "apps/client-portal" ]; then \
		cd apps/client-portal && npm run lint 2>/dev/null || echo "Lint script not available"; \
	else \
		echo "⚠️  client-portal directory not found"; \
	fi

# Docker operations
docker-build: ## Build all Docker images
	@echo "🐳 Building Docker images..."
	@if [ -d "apps/claims-api" ]; then \
		cd apps/claims-api && docker build -t insurance-platform/claims-api:local .; \
		echo "✅ claims-api image built"; \
	fi
	@if [ -d "apps/client-portal" ]; then \
		cd apps/client-portal && docker build -t insurance-platform/client-portal:local .; \
		echo "✅ client-portal image built"; \
	fi

docker-run: ## Run Docker containers locally
	@echo "🚀 Starting local Docker containers..."
	@docker run -d --name claims-api -p 8080:8080 insurance-platform/claims-api:local || true
	@docker run -d --name client-portal -p 3000:8080 insurance-platform/client-portal:local || true
	@echo "✅ Containers started:"
	@echo "  Claims API: http://localhost:8080"
	@echo "  Client Portal: http://localhost:3000"

docker-stop: ## Stop Docker containers
	@echo "🛑 Stopping Docker containers..."
	@docker stop claims-api client-portal 2>/dev/null || true
	@docker rm claims-api client-portal 2>/dev/null || true
	@echo "✅ Containers stopped and removed"

# Terraform operations
terraform-init: ## Initialize Terraform (dev environment)
	@echo "🏗️  Initializing Terraform..."
	@cd terraform/environments/dev && terraform init

terraform-plan: ## Plan Terraform changes (dev environment)
	@echo "📋 Planning Terraform changes..."
	@cd terraform/environments/dev && terraform plan

terraform-apply: ## Apply Terraform changes (dev environment)
	@echo "🚀 Applying Terraform changes..."
	@cd terraform/environments/dev && terraform apply

terraform-destroy: ## Destroy Terraform infrastructure (dev environment)
	@echo "💥 Destroying Terraform infrastructure..."
	@cd terraform/environments/dev && terraform destroy

terraform-validate: ## Validate Terraform configuration
	@echo "✅ Validating Terraform configuration..."
	@cd terraform/environments/dev && terraform validate
	@cd terraform/environments/prod && terraform validate

# Kubernetes operations
k8s-deploy: ## Deploy to local Kubernetes
	@echo "☸️  Deploying to Kubernetes..."
	@kubectl apply -f apps/claims-api/k8s-local.yaml
	@kubectl apply -f argo/applications/
	@echo "✅ Kubernetes deployment completed!"

k8s-status: ## Check Kubernetes deployment status
	@echo "📊 Kubernetes Status:"
	@kubectl get pods -n insurance-platform
	@kubectl get services -n insurance-platform

k8s-logs: ## Show application logs
	@echo "📜 Application Logs:"
	@kubectl logs -l app=claims-api -n insurance-platform --tail=50

# Security scanning
security-scan: ## Run security scans
	@echo "🔒 Running security scans..."
	@if command -v trivy >/dev/null 2>&1; then \
		trivy fs .; \
	else \
		echo "⚠️  Trivy not installed, install with: brew install trivy"; \
	fi

# Pre-commit
pre-commit: ## Run pre-commit hooks on all files
	@echo "🔧 Running pre-commit hooks..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit run --all-files; \
	else \
		echo "⚠️  pre-commit not installed, run: make setup"; \
	fi

# CI/CD
ci-local: lint test ## Run CI pipeline locally
	@echo "🔄 Local CI pipeline completed!"

# Quick development commands
dev: setup fmt lint test ## Full development cycle
	@echo "🚀 Development cycle completed!"

# Check all dependencies
check-deps: ## Check if all required tools are installed
	@echo "🔍 Checking dependencies..."
	@command -v terraform >/dev/null 2>&1 && echo "✅ Terraform" || echo "❌ Terraform (install from https://terraform.io)"
	@command -v kubectl >/dev/null 2>&1 && echo "✅ kubectl" || echo "❌ kubectl"
	@command -v docker >/dev/null 2>&1 && echo "✅ Docker" || echo "❌ Docker"
	@command -v go >/dev/null 2>&1 && echo "✅ Go" || echo "❌ Go"
	@command -v node >/dev/null 2>&1 && echo "✅ Node.js" || echo "❌ Node.js"
	@command -v npm >/dev/null 2>&1 && echo "✅ npm" || echo "❌ npm"
	@command -v helm >/dev/null 2>&1 && echo "✅ Helm" || echo "❌ Helm"
	@command -v pre-commit >/dev/null 2>&1 && echo "✅ pre-commit" || echo "❌ pre-commit" 