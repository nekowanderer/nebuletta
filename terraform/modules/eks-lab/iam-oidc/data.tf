# Data source definitions

# Get remote state from eks-cluster module
data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "dev-state-storage-s3"
    key    = "eks-lab/cluster/terraform.tfstate"
    region = var.aws_region
  }
}

# Get AWS Load Balancer Controller IAM policy from HTTP source
data "http" "alb_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.9.0/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}
