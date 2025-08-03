# Static EFS Persistent Volumes and Claims
# This approach is required for Fargate environments where CSI controllers cannot run

# The capacity matching rules of Kubernetes
# 1. PVC request ≤ PV capacity ... (O)
#   - PVC request 2Gi, PV provide 5Gi → match success (PVC request ≤ PV capacity)
#   - PVC can only use the capacity it requested (2Gi)
# 2. If PVC request > PV capacity ... (X)
#   - PVC cannot bind to the PV because it exceeds the PV capacity (5Gi)
#   - PVC cannot use the full capacity of the PV (5Gi)

# Static Persistent Volume for EFS
resource "kubernetes_persistent_volume" "efs_static_pv" {
  metadata {
    name = "${local.prefix}-efs-pv"
    labels = {
      environment = var.env
      project     = var.project
      module      = "${local.prefix}"
    }
  }

  spec {
    capacity = {
      storage = var.efs_pv_capacity
    }

    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "efs-static"
    volume_mode                      = "Filesystem"

    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = "${aws_efs_file_system.eks.id}::${aws_efs_access_point.eks.id}"
      }
    }
  }

  depends_on = [
    kubernetes_manifest.efs_csi_driver,
    aws_efs_access_point.eks
  ]
}

# Persistent Volume Claim for applications
resource "kubernetes_persistent_volume_claim" "efs_pvc" {
  metadata {
    name      = "${local.prefix}-efs-pvc"
    namespace = "default"
    labels = {
      environment = var.env
      project     = var.project
      module      = "${local.prefix}"
    }
  }

  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "efs-static"
    volume_name        = kubernetes_persistent_volume.efs_static_pv.metadata[0].name

    resources {
      requests = {
        storage = var.efs_pvc_request
      }
    }
  }

  depends_on = [kubernetes_persistent_volume.efs_static_pv]
}
