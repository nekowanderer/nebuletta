# Metrics Server validation and monitoring
# Note: Metrics Server is deployed as EKS addon in cluster module with Fargate tolerations

# Data source to check if metrics server addon is available
data "aws_eks_addon" "metrics_server" {
  cluster_name = var.cluster_name
  addon_name   = "metrics-server"

  depends_on = [
    data.terraform_remote_state.eks_cluster
  ]
}

# Note: Metrics Server deployment and service status are managed through EKS addon
# We rely on the EKS addon being active to ensure Metrics Server is available
# The HPA resources will automatically wait for metrics to be available
