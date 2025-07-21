stack {
  name        = "networking"
  description = "Networking of the infrastructure"
  id          = "4c124d0a-6fb2-450b-9f08-19cbd000335c"
  tags = [
    "dev",
    "dev-networking"
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
      source = "../../../modules/networking"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "networking"
      managed_by = global.managed_by
      vpc_cidr = "10.0.0.0/16"
      max_azs = 6
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

    output "availability_zones" {
      value = module.networking.availability_zones
    }

    output "public_subnet_cidrs" {
      value = module.networking.public_subnet_cidrs
    }

    output "private_subnet_cidrs" {
      value = module.networking.private_subnet_cidrs
    }
  }
}
