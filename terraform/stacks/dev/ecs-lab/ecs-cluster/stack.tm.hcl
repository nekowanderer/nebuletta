stack {
  name        = "ecs-cluster"
  description = "ECS cluster for containerized applications"
  id          = "2fc47019-16ca-4f61-89d8-9aaf73e10032"
  tags = [
    "dev",
    "ecs-cluster"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "ecs-cluster/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "ecs_cluster" {
      source = "../../../../modules/ecs-lab/ecs-cluster"
      env        = global.env
      aws_region = global.aws_region
      project    = global.project.name
      module_name = "ecs-cluster"
      managed_by = global.managed_by
      cluster_name = "my-cluster"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "cluster_id" {
      value = module.ecs_cluster.cluster_id
    }

    output "cluster_arn" {
      value = module.ecs_cluster.cluster_arn
    }

    output "cluster_name" {
      value = module.ecs_cluster.cluster_name
    }
  }
}
