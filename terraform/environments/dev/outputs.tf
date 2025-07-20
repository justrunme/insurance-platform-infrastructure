# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# EKS Outputs
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = module.eks.cluster_oidc_issuer_url
}

# Database Outputs
output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.main.port
}

# ECR Outputs
output "ecr_claims_api_repository_url" {
  description = "ECR repository URL for claims API"
  value       = aws_ecr_repository.claims_api.repository_url
}

output "ecr_client_portal_repository_url" {
  description = "ECR repository URL for client portal"
  value       = aws_ecr_repository.client_portal.repository_url
}

# S3 Outputs
output "s3_bucket_name" {
  description = "S3 bucket name for application data"
  value       = aws_s3_bucket.app_data.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN for application data"
  value       = aws_s3_bucket.app_data.arn
}

# kubectl configuration
output "kubectl_config" {
  description = "kubectl config command"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_id}"
} 