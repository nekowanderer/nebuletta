stack {
  name        = "networking"
  description = "networking"
  id          = "80476660-3586-42cf-893e-0c340d401ea4"
  tags = [
    "staging",
    "staging-networking"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "networking/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "networking" {
      source = "git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/networking?ref=v4.0.0"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "networking"
      managed_by = global.managed_by
      vpc_cidr = "10.1.0.0/16"
      azs = ["ap-northeast-1a", "ap-northeast-1c"]
      public_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
      private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "vpc_id" {
      value = module.networking.vpc_id
    }

    output "vpc_cidr" {
      value = module.networking.vpc_cidr
    }

    output "internet_gateway_id" {
      value = module.networking.internet_gateway_id
    }

    output "public_subnet_ids" {
      value = module.networking.public_subnet_ids
    }

    output "private_subnet_ids" {
      value = module.networking.private_subnet_ids
    }

    output "nat_gateway_ids" {
      value = module.networking.nat_gateway_ids
    }

    output "nat_gateway_public_ips" {
      value = module.networking.nat_gateway_public_ips
    }

    output "vpc_endpoint_s3_id" {
      value = module.networking.vpc_endpoint_s3_id
    }

    output "vpc_endpoint_dynamodb_id" {
      value = module.networking.vpc_endpoint_dynamodb_id
    }

    output "vpc_endpoint_ecr_api_id" {
      value = module.networking.vpc_endpoint_ecr_api_id
    }

    output "vpc_endpoint_ecr_dkr_id" {
      value = module.networking.vpc_endpoint_ecr_dkr_id
    }

    output "vpc_endpoint_logs_id" {
      value = module.networking.vpc_endpoint_logs_id
    }
  }
}
