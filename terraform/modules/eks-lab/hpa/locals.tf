# Local values calculation
locals {
  prefix = "${var.env}-${var.module_name}"
  common_tags = {
    Environment = var.env
    Project     = var.project
    ModuleName  = var.module_name
    Name        = local.prefix
    ManagedBy   = var.managed_by
  }

  # HPA configuration
  beta_hpa_name = "beta-app-deployment-hpa"
  prod_hpa_name = "prod-app-deployment-hpa"

  # Metrics Server configuration
  metrics_server_name      = "metrics-server"
  metrics_server_namespace = "kube-system"
}
