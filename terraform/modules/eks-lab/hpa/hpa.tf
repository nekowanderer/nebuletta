# HorizontalPodAutoscaler Configuration
# Manages automatic scaling based on CPU utilization

# HPA for Beta application
resource "kubernetes_horizontal_pod_autoscaler_v2" "beta" {
  count = var.enable_beta_hpa ? 1 : 0

  metadata {
    name      = local.beta_hpa_name
    namespace = var.hpa_target_namespace
    labels = merge(local.common_tags, {
      "app.kubernetes.io/name"      = "hpa"
      "app.kubernetes.io/component" = "autoscaler"
      "app.kubernetes.io/part-of"   = var.project
      "app.kubernetes.io/target"    = "beta"
    })
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "beta-app-deployment"
    }

    min_replicas = var.beta_hpa_min_replicas
    max_replicas = var.beta_hpa_max_replicas

    # CPU-based scaling metric
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.beta_hpa_cpu_target_percentage
        }
      }
    }

    # Scaling behavior configuration for beta (more aggressive for testing)
    behavior {
      scale_up {
        stabilization_window_seconds = 60
        select_policy                = "Max"
        policy {
          type           = "Percent"
          value          = 50
          period_seconds = 60
        }
        policy {
          type           = "Pods"
          value          = 2
          period_seconds = 60
        }
      }

      scale_down {
        stabilization_window_seconds = 300
        select_policy                = "Min"
        policy {
          type           = "Percent"
          value          = 10
          period_seconds = 60
        }
        policy {
          type           = "Pods"
          value          = 1
          period_seconds = 60
        }
      }
    }
  }

  # Wait for metrics server addon and target deployment to be ready
  depends_on = [
    data.aws_eks_addon.metrics_server,
    data.terraform_remote_state.eks_applications
  ]
}

# HPA for Production application
resource "kubernetes_horizontal_pod_autoscaler_v2" "prod" {
  count = var.enable_prod_hpa ? 1 : 0

  metadata {
    name      = local.prod_hpa_name
    namespace = var.hpa_target_namespace
    labels = merge(local.common_tags, {
      "app.kubernetes.io/name"      = "hpa"
      "app.kubernetes.io/component" = "autoscaler"
      "app.kubernetes.io/part-of"   = var.project
      "app.kubernetes.io/target"    = "production"
    })
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "prod-app-deployment"
    }

    min_replicas = var.prod_hpa_min_replicas
    max_replicas = var.prod_hpa_max_replicas

    # CPU-based scaling metric with higher threshold for prod
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = var.prod_hpa_cpu_target_percentage
        }
      }
    }

    # More conservative scaling behavior for production
    behavior {
      scale_up {
        stabilization_window_seconds = 120
        select_policy                = "Max"
        policy {
          type           = "Percent"
          value          = 25
          period_seconds = 120
        }
        policy {
          type           = "Pods"
          value          = 3
          period_seconds = 120
        }
      }

      scale_down {
        stabilization_window_seconds = 600
        select_policy                = "Min"
        policy {
          type           = "Percent"
          value          = 5
          period_seconds = 120
        }
        policy {
          type           = "Pods"
          value          = 1
          period_seconds = 120
        }
      }
    }
  }

  depends_on = [
    data.aws_eks_addon.metrics_server,
    data.terraform_remote_state.eks_applications
  ]
}
