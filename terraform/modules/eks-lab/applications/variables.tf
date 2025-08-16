# Variables for EKS Applications Module

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

variable "fargate_profile_name" {
  description = "Fargate profile name"
  type        = string
}

variable "app_namespace" {
  description = "Application namespace"
  type        = string
}

variable "beta_app_replicas" {
  description = "Number of replicas for beta application"
  type        = number
  validation {
    condition     = var.beta_app_replicas >= 1 && var.beta_app_replicas <= 10
    error_message = "Beta app replicas must be between 1 and 10."
  }
}

variable "prod_app_replicas" {
  description = "Number of replicas for production application"
  type        = number
  validation {
    condition     = var.prod_app_replicas >= 1 && var.prod_app_replicas <= 20
    error_message = "Production app replicas must be between 1 and 20."
  }
}

variable "beta_app_image" {
  description = "Docker image for beta application"
  type        = string
}

variable "prod_app_image" {
  description = "Docker image for production application"
  type        = string
}

variable "app_cpu_request" {
  description = "CPU request for application containers"
  type        = string
}

variable "app_cpu_limit" {
  description = "CPU limit for application containers"
  type        = string
}

variable "app_memory_request" {
  description = "Memory request for application containers"
  type        = string
}

variable "app_memory_limit" {
  description = "Memory limit for application containers"
  type        = string
}
