terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
  }

  required_version = ">= 1.11.4"
}

provider "aws" {
  region = var.aws_region
} 