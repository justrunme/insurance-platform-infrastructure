variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_log_types" {
  description = "List of control plane logging to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 7
}

variable "instance_types" {
  description = "Instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = "AL2_x86_64"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Maximum number of nodes unavailable at once during a version update"
  type        = number
  default     = 1
}

variable "key_pair_name" {
  description = "EC2 Key Pair name for SSH access to worker nodes"
  type        = string
  default     = null
}

variable "node_group_labels" {
  description = "Key-value map of Kubernetes labels for node group"
  type        = map(string)
  default = {
    Environment = "dev"
    Role        = "worker"
  }
}

variable "enable_vpc_cni" {
  description = "Enable VPC CNI addon"
  type        = bool
  default     = true
}

variable "enable_coredns" {
  description = "Enable CoreDNS addon"
  type        = bool
  default     = true
}

variable "enable_kube_proxy" {
  description = "Enable kube-proxy addon"
  type        = bool
  default     = true
}

variable "vpc_cni_version" {
  description = "Version of the VPC CNI addon"
  type        = string
  default     = null
}

variable "coredns_version" {
  description = "Version of the CoreDNS addon"
  type        = string
  default     = null
}

variable "kube_proxy_version" {
  description = "Version of the kube-proxy addon"
  type        = string
  default     = null
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "insurance-platform"
    ManagedBy   = "terraform"
  }
} 