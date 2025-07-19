globals {
    env        = "prod"
    aws_region = global.region
}

globals "backend" "s3" {
  bucket = "prod-state-storage-s3"
}

globals "backend" "dynamodb" {
  table = "prod-state-storage-locks"
}

generate_hcl "_terramate_generated_provider.tf" {
  content {
    provider "aws" {
      region = global.aws_region
    }
  }
} 
