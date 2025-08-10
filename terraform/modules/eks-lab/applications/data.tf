# Data sources for EKS Applications Module

# Get VPC and networking information
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = var.state_storage
    key    = "networking/terraform.tfstate"
    region = var.aws_region
  }
}

# Get EKS cluster information
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = var.state_storage
    key    = "eks-lab/cluster/terraform.tfstate"
    region = var.aws_region
  }
}

# Get Load Balancer Controller information (for dependencies)
data "terraform_remote_state" "lb_ctl" {
  backend = "s3"
  config = {
    bucket = var.state_storage
    key    = "eks-lab/lb-ctl/terraform.tfstate"
    region = var.aws_region
  }
}

# Get EKS cluster details
data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "main" {
  name = var.cluster_name
}
