# EKS Storage Module
# This module provides EFS storage and CSI driver for EKS clusters
# Provider configuration is handled by the shared eks-providers module

terraform {
  required_version = ">= 1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}
