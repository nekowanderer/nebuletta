variable "env" {
  description = "Environment name"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "module_name" {
  description = "Module name"
  type        = string
  default     = "ebs"
}

variable "managed_by" {
  description = "Managed by"
  type        = string
  default     = "Terraform"
}

variable "volume_size" {
  description = "Size of the EBS volume in GiB"
  type        = number
  default     = 20
}

variable "volume_type" {
  description = "Type of EBS volume (gp3, gp2, io1, io2, sc1, st1)"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1", "io2", "sc1", "st1"], var.volume_type)
    error_message = "Volume type must be one of: gp3, gp2, io1, io2, sc1, st1."
  }
}

variable "encrypted" {
  description = "Enable encryption for the EBS volume"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for EBS encryption (optional)"
  type        = string
  default     = null
}

variable "iops" {
  description = "IOPS for the volume (required for io1, io2, optional for gp3)"
  type        = number
  default     = null
}

variable "throughput" {
  description = "Throughput for gp3 volumes (125-1000 MiB/s)"
  type        = number
  default     = null

  validation {
    condition     = var.throughput == null || (var.throughput >= 125 && var.throughput <= 1000)
    error_message = "Throughput must be between 125 and 1000 MiB/s for gp3 volumes."
  }
}
