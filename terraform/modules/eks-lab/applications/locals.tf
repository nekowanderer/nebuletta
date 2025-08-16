# Local values for EKS Applications Module

locals {
  prefix = "${var.env}-${var.module_name}"

  common_tags = {
    Environment = var.env
    Project     = var.project
    Module      = var.module_name
    ManagedBy   = var.managed_by
    Region      = var.aws_region
  }

  # Application labels
  beta_app_labels = {
    "app.kubernetes.io/name"       = "beta-app-pod"
    "app.kubernetes.io/component"  = "application"
    "app.kubernetes.io/part-of"    = "nebuletta-eks-lab"
    "app.kubernetes.io/managed-by" = var.managed_by
    "app.kubernetes.io/version"    = "v1"
    "tier"                         = "beta"
  }

  prod_app_labels = {
    "app.kubernetes.io/name"       = "prod-app-pod"
    "app.kubernetes.io/component"  = "application"
    "app.kubernetes.io/part-of"    = "nebuletta-eks-lab"
    "app.kubernetes.io/managed-by" = var.managed_by
    "app.kubernetes.io/version"    = "v1"
    "tier"                         = "production"
  }
}
