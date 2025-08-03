# Load Balancer Controller IAM Role
resource "aws_iam_role" "load_balancer_controller" {
  name = "${local.prefix}-role"

  # OIDC trust relationshop - allow specific service account to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn # Trusted OIDC provider
        }
        Action = "sts:AssumeRoleWithWebIdentity" # Assume role via OIDC token
        Condition = {
          # Only allow the specific service account to assume this role
          # The following two conditions are required at the same time for assuming this role
          StringEquals = {
            "${replace(data.aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${replace(data.aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-role"
  })
}

# Attach Load Balancer Controller Policy to Role
resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  policy_arn = var.load_balancer_controller_policy_arn
  role       = aws_iam_role.load_balancer_controller.name
}
