# Ingress Resource for Path-based Routing

resource "kubernetes_ingress_v1" "ingress_path" {
  metadata {
    name      = "ingress-path"
    namespace = kubernetes_namespace.app_ns.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"                            = "alb"
      "alb.ingress.kubernetes.io/scheme"                       = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"                  = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path"             = "/"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = "15"
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds"  = "5"
      "alb.ingress.kubernetes.io/healthy-threshold-count"      = "2"
      "alb.ingress.kubernetes.io/unhealthy-threshold-count"    = "2"
      "alb.ingress.kubernetes.io/success-codes"                = "200"
      "alb.ingress.kubernetes.io/listen-ports"                 = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/group.name"                   = "nebuletta-eks-lab"
      "alb.ingress.kubernetes.io/tags"                         = "Environment=${var.env},Project=${var.project},ManagedBy=${var.managed_by}"
    }

    labels = merge(local.common_tags, {
      "app.kubernetes.io/name"       = "ingress-path"
      "app.kubernetes.io/component"  = "ingress"
      "app.kubernetes.io/managed-by" = var.managed_by
    })
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = "eks-lab.nebuletta.com"
      http {
        # Beta application path
        path {
          path      = "/beta"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.beta_app_service.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }

        # Production application path
        path {
          path      = "/prod"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.prod_app_service.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }

        # Default path - redirect to beta
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.beta_app_service.metadata[0].name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_v1.beta_app_service,
    kubernetes_service_v1.prod_app_service,
    data.terraform_remote_state.lb_ctl
  ]
}
