# Application Services

# Beta Application ClusterIP Service
resource "kubernetes_service_v1" "beta_app_service" {
  metadata {
    name      = "beta-app-service-clusterip"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
    labels    = local.beta_app_labels
  }

  spec {
    type = "ClusterIP"

    port {
      name        = "http"
      port        = 8080
      target_port = 80
      protocol    = "TCP"
    }

    selector = {
      "app.kubernetes.io/name" = "beta-app-pod"
      "tier"                   = "beta"
    }
  }

  depends_on = [
    kubernetes_deployment_v1.beta_app
  ]
}

# Production Application ClusterIP Service
resource "kubernetes_service_v1" "prod_app_service" {
  metadata {
    name      = "prod-app-service-clusterip"
    namespace = kubernetes_namespace.app_ns.metadata[0].name
    labels    = local.prod_app_labels
  }

  spec {
    type = "ClusterIP"

    port {
      name        = "http"
      port        = 8080
      target_port = 80
      protocol    = "TCP"
    }

    selector = {
      "app.kubernetes.io/name" = "prod-app-pod"
      "tier"                   = "production"
    }
  }

  depends_on = [
    kubernetes_deployment_v1.prod_app
  ]
}
