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

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "max_azs" {
  description = "Maximum number of AZs to use"
  type        = number
  default     = 2
  
  validation {
    condition     = var.max_azs >= 1 && var.max_azs <= 6
    error_message = "max_azs must be between 1 and 6."
  }
}
