# IAM roles and policies for EKS Fargate

# Fargate Pod Execution Role
resource "aws_iam_role" "fargate_pod_execution_role" {
  count = var.enable_fargate ? 1 : 0

  name = "${local.prefix}-fargate-pod-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks-fargate-pods.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-fargate-pod-execution-role"
  })
}

# Attach the AmazonEKSFargatePodExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "fargate_pod_execution_role_policy" {
  count      = var.enable_fargate ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod_execution_role[0].name
}
