globals {
  terraform_version = ">= 1.11.4"
  
  project = {
    name = "nebuletta"
  }
  
  region = "ap-northeast-1"
  managed_by = "Terramate"
}

generate_hcl "_terramate_generated_versions.tf" {
  content {
    terraform {
      required_version = global.terraform_version

      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.97"
        }
      }
    }
  }
} 