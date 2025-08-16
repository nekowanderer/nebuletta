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

variable "efs_pv_capacity" {
  description = "EFS Persistent Volume capacity"
  type        = string
  default     = "10Gi"

  validation {
    condition     = can(regex("^[0-9]+[KMGT]i$", var.efs_pv_capacity))
    error_message = "PV capacity must be in Kubernetes format (e.g., 10Gi, 5Mi, 1Ti)."
  }
}

variable "efs_pvc_request" {
  description = "EFS Persistent Volume Claim request size"
  type        = string
  default     = "5Gi"

  validation {
    condition     = can(regex("^[0-9]+[KMGT]i$", var.efs_pvc_request))
    error_message = "PVC request must be in Kubernetes format (e.g., 5Gi, 10Mi, 1Ti)."
  }
}
