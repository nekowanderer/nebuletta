stack {
  name        = "ecs-service"
  description = "ECS services for beta and prod environments"
  id          = "ac90149d-8d0a-4dab-8c0e-fd8e2185f12c"
  tags = [
    "dev",
    "dev-ecs-service"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "ecs-service/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_data.tf" {
  content {
    data "terraform_remote_state" "networking" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "networking/terraform.tfstate"
        region = global.aws_region
      }
    }

    data "terraform_remote_state" "ecs_cluster" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "ecs-cluster/terraform.tfstate"
        region = global.aws_region
      }
    }

    data "terraform_remote_state" "ecs_alb" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "ecs-alb/terraform.tfstate"
        region = global.aws_region
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "ecs_service" {
      source = "../../../../modules/ecs-lab/ecs-service"
      env        = global.env
      aws_region = global.aws_region
      project    = global.project.name
      module_name = "ecs-service"
      managed_by = global.managed_by
      cluster_arn = data.terraform_remote_state.ecs_cluster.outputs.cluster_arn
      cluster_name = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
      vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
      subnet_ids = data.terraform_remote_state.networking.outputs.public_subnet_ids
      security_group_id = data.terraform_remote_state.ecs_alb.outputs.security_group_id
      alb_listener_arn = data.terraform_remote_state.ecs_alb.outputs.alb_listener_arn
      beta_task_definition_family = "dev-ecs-task-beta"
      prod_task_definition_family = "dev-ecs-task-prod"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "beta_service_id" {
      value = module.ecs_service.beta_service_id
    }

    output "beta_service_name" {
      value = module.ecs_service.beta_service_name
    }

    output "beta_target_group_arn" {
      value = module.ecs_service.beta_target_group_arn
    }

    output "prod_service_id" {
      value = module.ecs_service.prod_service_id
    }

    output "prod_service_name" {
      value = module.ecs_service.prod_service_name
    }

    output "prod_target_group_arn" {
      value = module.ecs_service.prod_target_group_arn
    }
  }
}
