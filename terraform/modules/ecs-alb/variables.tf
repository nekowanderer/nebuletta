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

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "target_group_port" {
  description = "Target group port"
  type        = number
  default     = 80
}

variable "alb_listener_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}
