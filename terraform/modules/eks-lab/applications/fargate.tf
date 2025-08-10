# Fargate Pod Execution Role
resource "aws_iam_role" "fargate_pod_execution" {
  name = "${local.prefix}-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-fargate-pod-execution-role"
  })
}

# Attach EKS Fargate Pod Execution Role Policy
resource "aws_iam_role_policy_attachment" "fargate_pod_execution" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution.name
}

# Application Namespace
resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = var.app_namespace
    labels = merge(local.common_tags, {
      "app.kubernetes.io/name"       = var.app_namespace
      "app.kubernetes.io/managed-by" = var.managed_by
    })
  }
}

# Fargate Profile for Applications
resource "aws_eks_fargate_profile" "app_fp" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn
  subnet_ids             = data.terraform_remote_state.networking.outputs.private_subnet_ids

  selector {
    namespace = kubernetes_namespace.app_ns.metadata[0].name
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-fargate-profile"
  })

  depends_on = [
    aws_iam_role_policy_attachment.fargate_pod_execution
  ]
}
