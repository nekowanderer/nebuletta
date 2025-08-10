# Outputs for EKS Applications Module

output "fargate_profile_name" {
  description = "Name of the Fargate profile"
  value       = aws_eks_fargate_profile.app_fp.fargate_profile_name
}

output "fargate_profile_arn" {
  description = "ARN of the Fargate profile"
  value       = aws_eks_fargate_profile.app_fp.arn
}

output "fargate_profile_status" {
  description = "Status of the Fargate profile"
  value       = aws_eks_fargate_profile.app_fp.status
}

output "app_namespace" {
  description = "Application namespace name"
  value       = kubernetes_namespace.app_ns.metadata[0].name
}

output "beta_deployment_name" {
  description = "Name of the beta application deployment"
  value       = kubernetes_deployment_v1.beta_app.metadata[0].name
}

output "prod_deployment_name" {
  description = "Name of the production application deployment"
  value       = kubernetes_deployment_v1.prod_app.metadata[0].name
}

output "beta_service_name" {
  description = "Name of the beta application service"
  value       = kubernetes_service_v1.beta_app_service.metadata[0].name
}

output "prod_service_name" {
  description = "Name of the production application service"
  value       = kubernetes_service_v1.prod_app_service.metadata[0].name
}

output "ingress_name" {
  description = "Name of the ingress resource"
  value       = kubernetes_ingress_v1.ingress_path.metadata[0].name
}

output "ingress_hostname" {
  description = "Hostname of the ALB created by ingress"
  value       = try(kubernetes_ingress_v1.ingress_path.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "ingress_address" {
  description = "Address of the ALB created by ingress (same as hostname for ALB)"
  value       = try(kubernetes_ingress_v1.ingress_path.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "fargate_pod_execution_role_arn" {
  description = "ARN of the Fargate pod execution role"
  value       = aws_iam_role.fargate_pod_execution.arn
}
