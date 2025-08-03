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

  # Get VPC configuration from networking module
  vpc_config_from_remote = {
    vpc_id             = data.terraform_remote_state.infra_networking.outputs.vpc_id
    private_subnet_ids = data.terraform_remote_state.infra_networking.outputs.private_subnet_ids
  }

  # Validate VPC configuration
  vpc_config_valid = (
    local.vpc_config_from_remote.vpc_id != null &&
    length(local.vpc_config_from_remote.private_subnet_ids) >= 2
  )
}
