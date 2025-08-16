# EFS CSI Driver for EKS Fargate
# 
# Note: In Fargate environments, we cannot deploy the full CSI controller
# due to privileged container restrictions. We only register the CSI driver
# and use static provisioning with manually created PVs.
#
# This approach matches the AWS EKS Fargate documentation:
# https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

# CSI Driver object
resource "kubernetes_manifest" "efs_csi_driver" {
  manifest = {
    apiVersion = "storage.k8s.io/v1"
    kind       = "CSIDriver"
    metadata = {
      name = "efs.csi.aws.com"
    }
    spec = {
      attachRequired = false
    }
  }

  depends_on = [aws_efs_file_system.eks]
}

# Note: Storage Class removed for static provisioning approach
# In Fargate environments, we use static PVs instead of dynamic provisioning
