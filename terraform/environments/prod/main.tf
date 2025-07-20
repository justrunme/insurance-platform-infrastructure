# Terraform configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }

  # Commented out for local testing
  # backend "s3" {
  #   bucket         = "insurance-platform-terraform-state-prod"
  #   key            = "terraform.tfstate"
  #   region         = "us-west-2"
  #   dynamodb_table = "terraform-locks-prod"
  #   encrypt        = true
  # }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

  default_tags {
    tags = var.common_tags
  }
}

# Random string for unique resource naming
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = [
    cidrsubnet(var.vpc_cidr, 8, 1),
    cidrsubnet(var.vpc_cidr, 8, 2),
    cidrsubnet(var.vpc_cidr, 8, 3)
  ]
  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr, 8, 10),
    cidrsubnet(var.vpc_cidr, 8, 20),
    cidrsubnet(var.vpc_cidr, 8, 30)
  ]
  enable_nat_gateway   = true
  enable_flow_logs     = true

  common_tags = var.common_tags
}

# EKS Module
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "${var.project_name}-${var.environment}"
  kubernetes_version = var.cluster_version
  
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  # Security settings
  endpoint_private_access = true
  endpoint_public_access  = true
  public_access_cidrs     = ["0.0.0.0/0"]

  # Node group configuration
  instance_types   = var.node_group_instance_types
  capacity_type    = "ON_DEMAND"
  desired_capacity = var.node_group_desired_capacity
  max_capacity     = var.node_group_max_capacity
  min_capacity     = var.node_group_min_capacity

  # Labels for nodes
  node_group_labels = {
    Environment = var.environment
    NodeGroup   = "main"
  }

  common_tags = var.common_tags

  depends_on = [module.vpc]
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = module.vpc.private_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  })
}

# RDS Security Group
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds"
  })
}

# Generate random password for RDS
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Store RDS password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${var.project_name}-${var.environment}-db-password"
  description             = "RDS password for ${var.project_name} ${var.environment}"
  recovery_window_in_days = 7
  
  tags = var.common_tags
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    username = "postgres"
    password = random_password.db_password.result
  })
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"

  # Engine
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = var.db_instance_class

  # Storage
  allocated_storage     = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id           = aws_kms_key.rds.arn

  # Database
  db_name  = "insurance_platform"
  username = "postgres"
  password = random_password.db_password.result

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Backup
  backup_retention_period = var.db_backup_retention_period
  backup_window          = var.db_backup_window
  maintenance_window     = var.db_maintenance_window
  copy_tags_to_snapshot  = true

  # Monitoring
  performance_insights_enabled = var.enable_enhanced_monitoring
  monitoring_interval         = var.enable_enhanced_monitoring ? 60 : 0
  monitoring_role_arn         = var.enable_enhanced_monitoring ? aws_iam_role.rds_monitoring[0].arn : null

  # Security
  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-${var.environment}-db-final-snapshot"

  # Parameter group for optimization
  parameter_group_name = aws_db_parameter_group.main.name

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-database"
  })

  depends_on = [aws_cloudwatch_log_group.rds]
}

# KMS key for RDS encryption
resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS ${var.project_name}-${var.environment}"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds"
  })
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project_name}-${var.environment}-rds"
  target_key_id = aws_kms_key.rds.key_id
}

# RDS Parameter Group
resource "aws_db_parameter_group" "main" {
  family = "postgres15"
  name   = "${var.project_name}-${var.environment}-params"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  tags = var.common_tags
}

# CloudWatch Log Group for RDS
resource "aws_cloudwatch_log_group" "rds" {
  name              = "/aws/rds/instance/${var.project_name}-${var.environment}-db/postgresql"
  retention_in_days = 30

  tags = var.common_tags
}

# IAM role for RDS enhanced monitoring
resource "aws_iam_role" "rds_monitoring" {
  count = var.enable_enhanced_monitoring ? 1 : 0

  name = "${var.project_name}-${var.environment}-rds-monitoring"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  count = var.enable_enhanced_monitoring ? 1 : 0

  role       = aws_iam_role.rds_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# S3 bucket for application data
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.project_name}-${var.environment}-app-data-${random_string.bucket_suffix.result}"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-app-data"
  })
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
} 