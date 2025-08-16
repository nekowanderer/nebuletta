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

  # Extract OIDC issuer URL without protocol
  oidc_issuer_host = replace(var.oidc_issuer_url, "https://", "")

  # AWS EKS OIDC root CA thumbprint (fixed value for all AWS regions)
  # This is the official AWS-provided thumbprint for EKS OIDC identity providers
  oidc_thumbprint = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}
