# Outputs for EKS HPA Module

# Metrics Server outputs
output "metrics_server_deployment_name" {
  description = "Metrics Server deployment name"
  value       = local.metrics_server_name
}

output "metrics_server_namespace" {
  description = "Metrics Server namespace"
  value       = local.metrics_server_namespace
}

output "metrics_server_addon_version" {
  description = "Metrics Server addon version"
  value       = data.aws_eks_addon.metrics_server.addon_version
}

output "metrics_server_status" {
  description = "Metrics Server addon status"
  value       = data.aws_eks_addon.metrics_server.addon_version != null ? "ACTIVE" : "UNKNOWN"
}

# HPA configuration outputs
output "hpa_target_namespace" {
  description = "Target namespace for HPA"
  value       = var.hpa_target_namespace
}

output "beta_hpa_enabled" {
  description = "Whether beta HPA is enabled"
  value       = var.enable_beta_hpa
}

output "prod_hpa_enabled" {
  description = "Whether production HPA is enabled"
  value       = var.enable_prod_hpa
}

# Beta HPA outputs
output "beta_hpa_name" {
  description = "Beta HPA resource name"
  value       = var.enable_beta_hpa ? local.beta_hpa_name : null
}

output "beta_hpa_cpu_target_percentage" {
  description = "Beta HPA CPU target percentage"
  value       = var.beta_hpa_cpu_target_percentage
}

output "beta_hpa_min_replicas" {
  description = "Beta HPA minimum replicas"
  value       = var.beta_hpa_min_replicas
}

output "beta_hpa_max_replicas" {
  description = "Beta HPA maximum replicas"
  value       = var.beta_hpa_max_replicas
}

# Production HPA outputs
output "prod_hpa_name" {
  description = "Production HPA resource name"
  value       = var.enable_prod_hpa ? local.prod_hpa_name : null
}

output "prod_hpa_cpu_target_percentage" {
  description = "Production HPA CPU target percentage"
  value       = var.prod_hpa_cpu_target_percentage
}

output "prod_hpa_min_replicas" {
  description = "Production HPA minimum replicas"
  value       = var.prod_hpa_min_replicas
}

output "prod_hpa_max_replicas" {
  description = "Production HPA maximum replicas"
  value       = var.prod_hpa_max_replicas
}

# HPA status outputs
output "beta_hpa_status" {
  description = "Beta HPA configuration and status"
  value = var.enable_beta_hpa ? {
    name                  = kubernetes_horizontal_pod_autoscaler_v2.beta[0].metadata[0].name
    namespace             = kubernetes_horizontal_pod_autoscaler_v2.beta[0].metadata[0].namespace
    target_deployment     = kubernetes_horizontal_pod_autoscaler_v2.beta[0].spec[0].scale_target_ref[0].name
    min_replicas          = kubernetes_horizontal_pod_autoscaler_v2.beta[0].spec[0].min_replicas
    max_replicas          = kubernetes_horizontal_pod_autoscaler_v2.beta[0].spec[0].max_replicas
    cpu_target_percentage = kubernetes_horizontal_pod_autoscaler_v2.beta[0].spec[0].metric[0].resource[0].target[0].average_utilization
    enabled               = var.enable_beta_hpa
  } : null
}

output "prod_hpa_status" {
  description = "Production HPA configuration and status"
  value = var.enable_prod_hpa ? {
    name                  = kubernetes_horizontal_pod_autoscaler_v2.prod[0].metadata[0].name
    namespace             = kubernetes_horizontal_pod_autoscaler_v2.prod[0].metadata[0].namespace
    target_deployment     = kubernetes_horizontal_pod_autoscaler_v2.prod[0].spec[0].scale_target_ref[0].name
    min_replicas          = kubernetes_horizontal_pod_autoscaler_v2.prod[0].spec[0].min_replicas
    max_replicas          = kubernetes_horizontal_pod_autoscaler_v2.prod[0].spec[0].max_replicas
    cpu_target_percentage = kubernetes_horizontal_pod_autoscaler_v2.prod[0].spec[0].metric[0].resource[0].target[0].average_utilization
    enabled               = var.enable_prod_hpa
  } : null
}
