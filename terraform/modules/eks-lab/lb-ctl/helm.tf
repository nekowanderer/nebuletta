# AWS Load Balancer Controller Helm Chart
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts" # Equivalent to helm repo add eks https://aws.github.io/eks-charts
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.1" # Latest stable version compatible with Kubernetes 1.33

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.aws_region
      vpcId       = data.aws_eks_cluster.main.vpc_config[0].vpc_id

      serviceAccount = {
        create = false
        name   = kubernetes_service_account.load_balancer_controller.metadata[0].name
      }

      podLabels = local.common_tags

      resources = {
        limits = {
          cpu    = "200m"
          memory = "500Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "200Mi"
        }
      }

      nodeSelector = {}
      tolerations  = []

      # Enable webhook for better security
      enableShield      = false
      enableWaf         = false
      enableWafv2       = false
      enableCertManager = false

      # Logging configuration
      logLevel = "info"

      # Webhook configuration
      webhookTLS = {
        caCert = ""
        cert   = ""
        key    = ""
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.load_balancer_controller,
    aws_iam_role_policy_attachment.load_balancer_controller
  ]
}
