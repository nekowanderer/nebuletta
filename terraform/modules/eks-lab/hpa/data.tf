# Data sources for EKS HPA Module

# Get EKS cluster information
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = var.state_storage
    key    = "eks-lab/cluster/terraform.tfstate"
    region = var.aws_region
  }
}

# Get EKS applications information (for dependencies)
data "terraform_remote_state" "eks_applications" {
  backend = "s3"
  config = {
    bucket = var.state_storage
    key    = "eks-lab/applications/terraform.tfstate"
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
