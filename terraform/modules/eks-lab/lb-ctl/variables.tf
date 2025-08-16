variable "env" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "nebuletta"
}

variable "module_name" {
  description = "Module name"
  type        = string
}

variable "managed_by" {
  description = "Managed by"
  type        = string
  default     = "Terraform"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][-a-zA-Z0-9]*$", var.cluster_name))
    error_message = "Cluster name must start with a letter and can only contain letters, numbers, and hyphens."
  }
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN from eks-iam-oidc module"
  type        = string
}

variable "load_balancer_controller_policy_arn" {
  description = "Load Balancer Controller IAM policy ARN from eks-iam-oidc module"
  type        = string
}
