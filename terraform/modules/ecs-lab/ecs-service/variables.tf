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

variable "cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ECS services"
  type        = string
}

variable "alb_listener_arn" {
  description = "ALB listener ARN"
  type        = string
}

variable "beta_task_definition_family" {
  description = "Task definition family name for beta service"
  type        = string
}

variable "beta_task_definition_revision" {
  description = "Task definition revision for beta service"
  type        = number
  default     = 3
}

variable "prod_task_definition_family" {
  description = "Task definition family name for prod service"
  type        = string
}

variable "prod_task_definition_revision" {
  description = "Task definition revision for prod service"
  type        = number
  default     = 3
}
