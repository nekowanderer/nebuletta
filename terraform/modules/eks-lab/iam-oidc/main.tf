terraform {
  required_version = ">= 1.11.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.3"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}
