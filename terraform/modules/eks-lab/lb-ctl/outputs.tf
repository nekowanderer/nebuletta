# Output value definitions

output "load_balancer_controller_role_arn" {
  description = "Load Balancer Controller IAM role ARN"
  value       = aws_iam_role.load_balancer_controller.arn
}

output "load_balancer_controller_role_name" {
  description = "Load Balancer Controller IAM role name"
  value       = aws_iam_role.load_balancer_controller.name
}

output "load_balancer_controller_service_account_name" {
  description = "Load Balancer Controller service account name"
  value       = kubernetes_service_account.load_balancer_controller.metadata[0].name
}

output "load_balancer_controller_service_account_namespace" {
  description = "Load Balancer Controller service account namespace"
  value       = kubernetes_service_account.load_balancer_controller.metadata[0].namespace
}

output "helm_release_name" {
  description = "Helm release name for Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.name
}

output "helm_release_namespace" {
  description = "Helm release namespace for Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.namespace
}

output "helm_release_status" {
  description = "Helm release status for Load Balancer Controller"
  value       = helm_release.aws_load_balancer_controller.status
}
