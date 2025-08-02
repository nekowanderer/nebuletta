# EKS Cluster main resource definition
# Create EKS cluster and related IAM resources

# Validate VPC configuration
resource "null_resource" "vpc_config_validation" {
  count = local.vpc_config_valid ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: Invalid VPC configuration. Please ensure networking module is deployed and vpc_config is properly configured.' && exit 1"
  }
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = concat(local.vpc_config_from_remote.private_subnet_ids, local.vpc_config_from_remote.public_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Ensure IAM role and VPC configuration exist before cluster creation
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.vpc_resource_controller,
    null_resource.vpc_config_validation,
  ]

  tags = local.common_tags

  lifecycle {
    create_before_destroy = false
  }
}

# EKS cluster service role
resource "aws_iam_role" "cluster" {
  name = "${local.prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

# Attach EKS cluster policy
resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Attach EKS VPC resource controller policy (replaces old Service Policy)
resource "aws_iam_role_policy_attachment" "vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}
