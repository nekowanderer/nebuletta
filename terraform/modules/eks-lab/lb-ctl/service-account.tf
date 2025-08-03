# Kubernetes Service Account for Load Balancer Controller
resource "kubernetes_service_account" "load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    # Link to the IAM role so the pods can take on the IAM permissions
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.load_balancer_controller.arn
    }

    labels = merge(local.common_tags, {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = var.managed_by
    })
  }

  depends_on = [aws_iam_role.load_balancer_controller]
}
