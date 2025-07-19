stack {
  name        = "archive-bucket"
  description = "Archive S3 bucket"
  id          = "400fbc60-35dd-4998-9804-0a58ed3b3c61"
  tags = [
    "dev",
    "dev-archive-bucket"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "s3-archive-bucket/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "archive-bucket" {
      source = "../../../../modules/s3/archive-bucket"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "archive-bucket"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "archive_bucket_name" {
      value = module.archive-bucket.archive_bucket_name
    }

    output "archive_bucket_arn" {
      value = module.archive-bucket.archive_bucket_arn
    }
  }
}