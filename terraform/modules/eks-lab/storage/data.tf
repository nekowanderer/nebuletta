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

# Get remote state from eks-cluster module
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "dev-state-storage-s3"
    key    = "eks-lab/cluster/terraform.tfstate"
    region = var.aws_region
  }
}

# Get available zones list
data "aws_availability_zones" "available" {
  state = "available"
}
