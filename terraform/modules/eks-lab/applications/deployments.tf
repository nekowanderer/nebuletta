# Application Deployments

# Beta Application Deployment
resource "kubernetes_deployment_v1" "beta_app" {
  metadata {
    name      = "beta-app-deployment"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
    labels    = local.beta_app_labels
  }

  spec {
    replicas = var.beta_app_replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "beta-app-pod"
        "tier"                   = "beta"
      }
    }

    template {
      metadata {
        labels = local.beta_app_labels
      }

      spec {
        container {
          image = var.beta_app_image
          name  = "beta-app-container"

          port {
            container_port = 80
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = var.app_cpu_limit
              memory = var.app_memory_limit
            }
            requests = {
              cpu    = var.app_cpu_request
              memory = var.app_memory_request
            }
          }

          # Health checks
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Environment variables
          env {
            name  = "APP_VERSION"
            value = "beta-v1"
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    aws_eks_fargate_profile.app_fp
  ]
}

# Production Application Deployment
resource "kubernetes_deployment_v1" "prod_app" {
  metadata {
    name      = "prod-app-deployment"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
    labels    = local.prod_app_labels
  }

  spec {
    replicas = var.prod_app_replicas

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "prod-app-pod"
        "tier"                   = "production"
      }
    }

    template {
      metadata {
        labels = local.prod_app_labels
      }

      spec {
        container {
          image = var.prod_app_image
          name  = "prod-app-container"

          port {
            container_port = 80
            protocol       = "TCP"
          }

          resources {
            limits = {
              cpu    = var.app_cpu_limit
              memory = var.app_memory_limit
            }
            requests = {
              cpu    = var.app_cpu_request
              memory = var.app_memory_request
            }
          }

          # Health checks
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          # Environment variables
          env {
            name  = "APP_VERSION"
            value = "prod-v1"
          }

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    aws_eks_fargate_profile.app_fp
  ]
}
