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

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string

  validation {
    condition     = var.kubernetes_version == "1.33"
    error_message = "This module only supports Kubernetes version 1.33 (AWS EKS latest stable version as of 2025-08)."
  }
}

variable "enable_fargate" {
  description = "Enable Fargate profiles for the EKS cluster"
  type        = bool
  default     = true
}

variable "fargate_namespaces" {
  description = "List of namespaces that should run on Fargate"
  type        = list(string)
  default     = ["kube-system", "default"]
}

# EKS Addons version variables
variable "vpc_cni_addon_version" {
  description = "VPC CNI addon version"
  type        = string
}

variable "kube_proxy_addon_version" {
  description = "Kube-proxy addon version"
  type        = string
}

variable "coredns_addon_version" {
  description = "CoreDNS addon version"
  type        = string
}

variable "metrics_server_addon_version" {
  description = "Metrics Server addon version"
  type        = string
}
