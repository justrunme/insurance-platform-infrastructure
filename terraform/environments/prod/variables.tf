# Environment Configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "insurance-platform"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

# EKS Configuration
variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.29"
}

variable "node_group_instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)
  default     = ["m5.large", "m5.xlarge"] # Larger instances for production
}

variable "node_group_desired_capacity" {
  description = "Desired number of nodes"
  type        = number
  default     = 6 # Higher capacity for production
}

variable "node_group_max_capacity" {
  description = "Maximum number of nodes"
  type        = number
  default     = 20 # Higher max capacity for production
}

variable "node_group_min_capacity" {
  description = "Minimum number of nodes"
  type        = number
  default     = 3 # Higher minimum for production
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.r5.large" # Larger instance for production
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 500 # More storage for production
}

variable "db_max_allocated_storage" {
  description = "RDS maximum allocated storage in GB"
  type        = number
  default     = 2000 # Higher max storage for production
}

variable "db_backup_retention_period" {
  description = "Database backup retention period in days"
  type        = number
  default     = 30 # Longer retention for production
}

variable "db_backup_window" {
  description = "Database backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Database maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

# Monitoring Configuration
variable "enable_enhanced_monitoring" {
  description = "Enable enhanced monitoring"
  type        = bool
  default     = true # Always enabled for production
}

# Security Configuration
variable "enable_cluster_encryption" {
  description = "Enable EKS cluster encryption"
  type        = bool
  default     = true # Always enabled for production
}

# Common tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "insurance-platform"
    ManagedBy   = "terraform"
    CostCenter  = "engineering"
    Compliance  = "gdpr-iso27001"
  }
} 