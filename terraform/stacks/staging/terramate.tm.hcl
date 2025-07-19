globals {
    env        = "staging"
    aws_region = global.region
}

globals "backend" "s3" {
  bucket = "staging-state-storage-s3"
}

globals "backend" "dynamodb" {
  table = "staging-state-storage-locks"
}

generate_hcl "_terramate_generated_provider.tf" {
  content {
    provider "aws" {
      region = global.aws_region
    }
  }
} 
