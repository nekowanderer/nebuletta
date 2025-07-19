stack {
  name        = "general-bucket"
  description = "General S3 bucket"
  id          = "d4d26207-7820-48e9-b49c-6a7171c9be8d"
  tags = [
    "dev",
    "dev-general-bucket"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "s3-general-bucket/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "general-bucket" {
      source = "../../../../modules/s3/general-bucket"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "general-bucket"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "general_bucket_name" {
      value = module.general-bucket.general_bucket_name
    }

    output "general_bucket_arn" {
      value = module.general-bucket.general_bucket_arn
    }
  }
}
