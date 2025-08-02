# Create OIDC Identity Provider and Load Balancer Controller IAM Policy

# OIDC Identity Provider for EKS cluster
resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [local.oidc_thumbprint]
  url             = var.oidc_issuer_url

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-oidc-provider"
  })

  lifecycle {
    create_before_destroy = false
  }
}

# IAM Policy for AWS Load Balancer Controller
resource "aws_iam_policy" "alb_controller" {
  name        = "${local.prefix}-alb-controller-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = data.http.alb_controller_policy.response_body

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-alb-controller-policy"
  })

  lifecycle {
    create_before_destroy = false
  }
}
