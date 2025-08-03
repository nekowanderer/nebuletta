locals {
  prefix = "${var.env}-${var.module_name}"

  common_tags = {
    Environment = var.env
    Project     = var.project
    Module      = var.module_name
    ManagedBy   = var.managed_by
    Region      = var.aws_region
  }
}
