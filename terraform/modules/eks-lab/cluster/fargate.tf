# EKS Fargate profiles for serverless pod execution

# Default Fargate profile for specified namespaces
resource "aws_eks_fargate_profile" "default" {
  count                  = var.enable_fargate ? 1 : 0
  cluster_name           = aws_eks_cluster.main.name
  fargate_profile_name   = "${local.prefix}-fp-default"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role[0].arn

  # Use private subnets for Fargate pods
  subnet_ids = local.vpc_config_from_remote.private_subnet_ids

  # Create selectors for each namespace
  dynamic "selector" {
    for_each = var.fargate_namespaces
    content {
      namespace = selector.value
    }
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-fp-default"
  })

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution_role_policy
  ]
}
