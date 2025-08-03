# EKS cluster OIDC issuer URL
data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

# Current AWS caller identity
data "aws_caller_identity" "current" {}

# Current AWS region
data "aws_region" "current" {}
