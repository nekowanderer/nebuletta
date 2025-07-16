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

variable "beta_task_definition_family" {
  description = "Beta task definition family name"
  type        = string
}

variable "prod_task_definition_family" {
  description = "Prod task definition family name"
  type        = string
}

variable "beta_container_name" {
  description = "Beta container name"
  type        = string
}

variable "prod_container_name" {
  description = "Prod container name"
  type        = string
}

variable "beta_container_image" {
  description = "Beta container image"
  type        = string
}

variable "prod_container_image" {
  description = "Prod container image"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Task CPU (1024 = 1 vCPU)"
  type        = number
  default     = 1024
}

variable "memory" {
  description = "Task memory in MB"
  type        = number
  default     = 3072
}
