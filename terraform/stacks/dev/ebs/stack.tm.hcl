stack {
  name        = "ebs"
  description = "EBS volumes for dev environment"
  id          = "5797ab68-00e5-427c-bb7e-623ea99c8814"
  tags = [
    "dev",
    "dev-ebs"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "ebs/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "ebs" {
      source = "../../../modules/ebs"
      
      env         = global.env
      project     = global.project.name
      module_name = "ebs"
      managed_by  = global.managed_by
      
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
      throughput  = 125
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "volume_ids" {
      description = "Map of AZ to EBS volume IDs"
      value       = module.ebs.volume_ids
    }

    output "volume_arns" {
      description = "Map of AZ to EBS volume ARNs"
      value       = module.ebs.volume_arns
    }

    output "volume_sizes" {
      description = "Map of AZ to EBS volume sizes"
      value       = module.ebs.volume_sizes
    }

    output "availability_zones" {
      description = "List of availability zones where volumes were created"
      value       = module.ebs.availability_zones
    }

    output "volumes_info" {
      description = "Complete information about all created volumes"
      value       = module.ebs.volumes_info
    }
  }
}
