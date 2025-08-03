# Output value definitions

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = aws_eks_cluster.main.arn
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_iam_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = aws_iam_role.cluster.arn
}

output "cluster_version" {
  description = "EKS cluster Kubernetes version"
  value       = aws_eks_cluster.main.version
}

output "cluster_status" {
  description = "EKS cluster status"
  value       = aws_eks_cluster.main.status
}

output "cluster_platform_version" {
  description = "EKS cluster platform version"
  value       = aws_eks_cluster.main.platform_version
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster CA certificate data (base64 encoded)"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "fargate_profile_name" {
  description = "Name of the default Fargate profile"
  value       = var.enable_fargate ? aws_eks_fargate_profile.default[0].fargate_profile_name : null
}

output "fargate_profile_arn" {
  description = "ARN of the default Fargate profile"
  value       = var.enable_fargate ? aws_eks_fargate_profile.default[0].arn : null
}

output "fargate_pod_execution_role_arn" {
  description = "ARN of the Fargate pod execution role"
  value       = var.enable_fargate ? aws_iam_role.fargate_pod_execution_role[0].arn : null
}
