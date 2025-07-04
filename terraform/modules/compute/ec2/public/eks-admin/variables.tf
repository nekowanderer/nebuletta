variable "env" {
  description = "Prefix for environment names"
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
  description = "VPC ID from remote state"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs from remote state"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "SSH key name"
  type        = string
  default     = ""
}
