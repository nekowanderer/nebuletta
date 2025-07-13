stack {
  name        = "ecs-alb"
  description = "Application Load Balancer for AWS ECS"
  id          = "3c5c0754-0c08-4d24-8e16-74127cf280ed"
  tags = [
    "dev",
    "ecs-alb"
  ]

  after = [
    "/terraform/stacks/dev/networking"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "ecs-alb/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_terraform_remote_state.tf" {
  content {
    data "terraform_remote_state" "infra_networking" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "networking/terraform.tfstate"
        region = global.aws_region
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "app_alb" {
      source = "../../../modules/ecs-alb"
      
      env               = global.env
      aws_region        = global.aws_region
      project           = global.project.name
      module_name       = "ecs-alb"
      managed_by        = global.managed_by
      
      vpc_id            = data.terraform_remote_state.infra_networking.outputs.vpc_id
      public_subnet_ids = data.terraform_remote_state.infra_networking.outputs.public_subnet_ids
      azs               = ["ap-northeast-1a", "ap-northeast-1c"]
      
      target_group_port   = 80
      alb_listener_port   = 80
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "alb_id" {
      description = "The ID of the Application Load Balancer"
      value       = module.app_alb.alb_id
    }

    output "alb_arn" {
      description = "The ARN of the Application Load Balancer"
      value       = module.app_alb.alb_arn
    }

    output "alb_dns_name" {
      description = "The DNS name of the Application Load Balancer"
      value       = module.app_alb.alb_dns_name
    }

    output "alb_zone_id" {
      description = "The zone ID of the Application Load Balancer"
      value       = module.app_alb.alb_zone_id
    }

    output "target_group_id" {
      description = "The ID of the target group"
      value       = module.app_alb.target_group_id
    }

    output "target_group_arn" {
      description = "The ARN of the target group"
      value       = module.app_alb.target_group_arn
    }

    output "security_group_id" {
      description = "The ID of the ALB security group"
      value       = module.app_alb.security_group_id
    }

    output "alb_listener_arn" {
      description = "The ARN of the ALB listener"
      value       = module.app_alb.alb_listener_arn
    }
  }
}
