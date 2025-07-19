stack {
  name        = "ecs-task"
  description = "ECS Task Definitions for beta and prod environments"
  id          = "e84aebda-b4d1-4a0a-b2a6-836d024c69a6"
  tags = [
    "dev",
    "dev-ecs-task"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "ecs-task/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "ecs_task" {
      source = "../../../../modules/ecs-lab/ecs-task"
      
      env               = global.env
      aws_region        = global.aws_region
      project           = global.project.name
      module_name       = "ecs-task"
      managed_by        = global.managed_by
      
      beta_task_definition_family = "my-taskdef-beta"
      prod_task_definition_family = "my-taskdef-prod"
      beta_container_name         = "my-container-beta"
      prod_container_name         = "my-container-prod"
      beta_container_image        = "uopsdod/k8s-hostname-amd64-beta"
      prod_container_image        = "uopsdod/k8s-hostname-amd64-prod"
      container_port              = 80
      cpu                         = 1024
      memory                      = 3072
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "beta_task_definition_arn" {
      description = "The ARN of the beta task definition"
      value       = module.ecs_task.beta_task_definition_arn
    }

    output "beta_task_definition_family" {
      description = "The family of the beta task definition"
      value       = module.ecs_task.beta_task_definition_family
    }

    output "beta_task_definition_revision" {
      description = "The revision of the beta task definition"
      value       = module.ecs_task.beta_task_definition_revision
    }

    output "prod_task_definition_arn" {
      description = "The ARN of the prod task definition"
      value       = module.ecs_task.prod_task_definition_arn
    }

    output "prod_task_definition_family" {
      description = "The family of the prod task definition"
      value       = module.ecs_task.prod_task_definition_family
    }

    output "prod_task_definition_revision" {
      description = "The revision of the prod task definition"
      value       = module.ecs_task.prod_task_definition_revision
    }
  }
}
