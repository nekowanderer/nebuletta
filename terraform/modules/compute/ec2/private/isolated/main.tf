terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97"
    }
  }

  required_version = ">= 1.11.4"
}

provider "aws" {
  region = var.aws_region
}
