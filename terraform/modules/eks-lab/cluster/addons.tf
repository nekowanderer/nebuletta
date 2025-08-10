# EKS Addons Configuration
# Manages essential EKS addons: vpc-cni, kube-proxy, coredns, metrics-server
# CoreDNS and metrics-server are configured with Fargate tolerations for proper scheduling

# VPC CNI addon - handles pod networking
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpc_cni_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vpc-cni-addon"
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.default
  ]
}

# Kube-proxy addon - handles service networking
resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kube_proxy_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-kube-proxy-addon"
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.default
  ]
}

# CoreDNS addon - handles DNS resolution with Fargate tolerations
resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  configuration_values = jsonencode({
    tolerations = [
      {
        key      = "CriticalAddonsOnly"
        operator = "Exists"
      },
      {
        key    = "node-role.kubernetes.io/control-plane"
        effect = "NoSchedule"
      },
      {
        key               = "node.kubernetes.io/not-ready"
        effect            = "NoExecute"
        tolerationSeconds = 300
      },
      {
        key               = "node.kubernetes.io/unreachable"
        effect            = "NoExecute"
        tolerationSeconds = 300
      },
      {
        key      = "eks.amazonaws.com/compute-type"
        operator = "Equal"
        value    = "fargate"
        effect   = "NoSchedule"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-coredns-addon"
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.default
  ]
}

# Metrics Server addon - handles metrics collection with Fargate tolerations
resource "aws_eks_addon" "metrics_server" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "metrics-server"
  addon_version               = var.metrics_server_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  configuration_values = jsonencode({
    tolerations = [
      {
        key      = "CriticalAddonsOnly"
        operator = "Exists"
      },
      {
        key    = "node-role.kubernetes.io/control-plane"
        effect = "NoSchedule"
      },
      {
        key               = "node.kubernetes.io/not-ready"
        effect            = "NoExecute"
        tolerationSeconds = 300
      },
      {
        key               = "node.kubernetes.io/unreachable"
        effect            = "NoExecute"
        tolerationSeconds = 300
      },
      {
        key      = "eks.amazonaws.com/compute-type"
        operator = "Equal"
        value    = "fargate"
        effect   = "NoSchedule"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-metrics-server-addon"
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.default
  ]
}
