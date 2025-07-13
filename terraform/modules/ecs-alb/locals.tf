locals {
  prefix = "${var.env}-${var.module_name}"
  common_tags = {
    Environment = var.env
    Project     = var.project
    ModuleName  = var.module_name
    Name        = "${local.prefix}"
    ManagedBy   = var.managed_by
  }

  alb_name            = local.prefix
  target_group_name   = "${local.prefix}-tg"
  security_group_name = "${local.prefix}-sg"
}
