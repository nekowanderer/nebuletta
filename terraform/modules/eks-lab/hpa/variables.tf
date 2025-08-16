# Variables for EKS HPA Module

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
}

variable "module_name" {
  description = "Module name"
  type        = string
}

variable "managed_by" {
  description = "Managed by identifier"
  type        = string
  default     = "terraform"
}

variable "state_storage" {
  description = "State storage bucket"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "hpa_target_namespace" {
  description = "Target namespace for HPA"
  type        = string
}

# Beta app HPA configuration
variable "enable_beta_hpa" {
  description = "Enable HPA for beta application"
  type        = bool
  default     = true
}

variable "beta_hpa_cpu_target_percentage" {
  description = "Target CPU utilization percentage for beta HPA"
  type        = number
  default     = 10
  validation {
    condition     = var.beta_hpa_cpu_target_percentage > 0 && var.beta_hpa_cpu_target_percentage <= 100
    error_message = "Beta HPA CPU target percentage must be between 1 and 100."
  }
}

variable "beta_hpa_min_replicas" {
  description = "Minimum number of replicas for beta HPA"
  type        = number
  default     = 1
  validation {
    condition     = var.beta_hpa_min_replicas >= 1
    error_message = "Beta HPA minimum replicas must be at least 1."
  }
}

variable "beta_hpa_max_replicas" {
  description = "Maximum number of replicas for beta HPA"
  type        = number
  default     = 10
  validation {
    condition     = var.beta_hpa_max_replicas >= 1 && var.beta_hpa_max_replicas <= 100
    error_message = "Beta HPA maximum replicas must be between 1 and 100."
  }
}

# Prod app HPA configuration
variable "enable_prod_hpa" {
  description = "Enable HPA for production application"
  type        = bool
  default     = true
}

variable "prod_hpa_cpu_target_percentage" {
  description = "Target CPU utilization percentage for prod HPA"
  type        = number
  default     = 70
  validation {
    condition     = var.prod_hpa_cpu_target_percentage > 0 && var.prod_hpa_cpu_target_percentage <= 100
    error_message = "Prod HPA CPU target percentage must be between 1 and 100."
  }
}

variable "prod_hpa_min_replicas" {
  description = "Minimum number of replicas for prod HPA"
  type        = number
  default     = 3
  validation {
    condition     = var.prod_hpa_min_replicas >= 1
    error_message = "Prod HPA minimum replicas must be at least 1."
  }
}

variable "prod_hpa_max_replicas" {
  description = "Maximum number of replicas for prod HPA"
  type        = number
  default     = 20
  validation {
    condition     = var.prod_hpa_max_replicas >= 1 && var.prod_hpa_max_replicas <= 100
    error_message = "Prod HPA maximum replicas must be between 1 and 100."
  }
}


variable "metrics_server_version" {
  description = "Metrics Server version to deploy"
  type        = string
}
