locals {
  prefix = "${var.env}-${var.module_name}"
  common_tags = {
    Environment = var.env
    Project     = var.project
    ModuleName  = var.module_name
    Name        = "${local.prefix}"
    ManagedBy   = var.managed_by
  }
} 