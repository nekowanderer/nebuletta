# Shared Terramate template for EKS Kubernetes provider configuration
# This template can be imported and customized in any stack that needs K8s provider

# Template for generating Kubernetes provider configuration for EKS
# Import this in your stack.tm.hcl with: 
# import {
#   source = "../../shared/terramate-templates/eks-k8s-provider.tm.hcl"
# }

# Kubernetes provider configuration for EKS cluster authentication
# 
# This provider configuration enables Terraform to interact with the EKS cluster's Kubernetes API.
# It uses three key components for secure authentication:
#
# 1. CLUSTER ENDPOINT: Retrieved from the eks-cluster module's remote state
#    - Points to the EKS cluster's API server endpoint (e.g., https://ABC123.gr7.ap-northeast-1.eks.amazonaws.com)
#
# 2. CLUSTER CA CERTIFICATE: Retrieved and decoded from eks-cluster module's remote state  
#    - Used to verify the authenticity of the EKS API server during TLS handshake
#    - Prevents man-in-the-middle attacks
#
# 3. EXEC AUTHENTICATION: Uses AWS CLI to dynamically obtain temporary bearer tokens
#    - AWS EKS integration with Kubernetes client-go credential plugins (k8s.io/client-go/plugin/pkg/client/auth/exec)
#    - 'aws eks get-token' returns a temporary JWT bearer token (valid ~15 minutes)
#    - Token is automatically included in HTTP Authorization headers: "Authorization: Bearer <token>"
#    - EKS API server validates the token via AWS STS and checks IAM permissions
#    - Tokens auto-refresh on expiration, no manual credential management needed
#
# This approach provides:
# - ✅ Secure, temporary credentials (no long-lived tokens)
# - ✅ Automatic token refresh 
# - ✅ Integration with AWS IAM permissions
# - ✅ Support for role assumption and cross-account access
generate_hcl "_terramate_generated_k8s_provider.tf" {
  content {
    provider "kubernetes" {
      host                   = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
      cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data)

      exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command     = "aws"
        args = [
          "eks",
          "get-token",
          "--cluster-name",
          data.terraform_remote_state.eks_cluster.outputs.cluster_name,
          "--region",
          global.aws_region
        ]
      }
    }
  }
}
