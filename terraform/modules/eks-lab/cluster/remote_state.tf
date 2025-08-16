# Data source definitions

# Get remote state from networking module
data "terraform_remote_state" "infra_networking" {
  backend = "s3"
  config = {
    bucket = "dev-state-storage-s3"
    key    = "networking/terraform.tfstate"
    region = var.aws_region
  }
}

# Get current AWS identity information
data "aws_caller_identity" "current" {}

# Get current AWS region information
data "aws_region" "current" {}

# Get available zones list
data "aws_availability_zones" "available" {
  state = "available"
}
