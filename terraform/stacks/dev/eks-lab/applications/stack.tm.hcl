stack {
  name        = "applications"
  description = "EKS applications, Fargate profile, services, and ingress"
  id          = "ab2c6ef8-4d9a-4f1e-8c3b-7e9a5b4c2d1f"
  tags = [
    "dev",
    "dev-eks-applications",
    "eks-lab"
  ]

  after = [
    "/terraform/stacks/dev/eks-lab/lb-ctl"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "eks-lab/applications/terraform.tfstate"
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

    data "terraform_remote_state" "eks_cluster" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "eks-lab/cluster/terraform.tfstate"
        region = global.aws_region
      }
    }

    data "terraform_remote_state" "eks_lb_ctl" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "eks-lab/lb-ctl/terraform.tfstate"
        region = global.aws_region
      }
    }
  }
}

# Import shared Kubernetes provider template
import {
  source = "../../shared/terramate-templates/eks-k8s-provider.tm.hcl"
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "eks_applications" {
      source = "../../../../modules/eks-lab/applications"
      
      env         = global.env
      aws_region  = global.aws_region
      project     = global.project.name
      module_name = "eks-applications"
      managed_by  = global.managed_by
      state_storage = global.backend.s3.bucket
      cluster_name = data.terraform_remote_state.eks_cluster.outputs.cluster_name

      fargate_profile_name = "nebuletta-app-fp"
      app_namespace        = "nebuletta-app-ns"
      beta_app_replicas    = 3
      beta_app_image       = "uopsdod/k8s-hostname-amd64-beta:v1"
      prod_app_replicas    = 3
      prod_app_image       = "uopsdod/k8s-hostname-amd64-prod:v1"

      app_cpu_request      = "200m"
      app_cpu_limit        = "500m"
      app_memory_request   = "256Mi"
      app_memory_limit     = "512Mi"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "fargate_profile_name" {
      value = module.eks_applications.fargate_profile_name
    }

    output "fargate_profile_arn" {
      value = module.eks_applications.fargate_profile_arn
    }

    output "fargate_profile_status" {
      value = module.eks_applications.fargate_profile_status
    }

    output "app_namespace" {
      value = module.eks_applications.app_namespace
    }

    output "beta_deployment_name" {
      value = module.eks_applications.beta_deployment_name
    }

    output "prod_deployment_name" {
      value = module.eks_applications.prod_deployment_name
    }

    output "beta_service_name" {
      value = module.eks_applications.beta_service_name
    }

    output "prod_service_name" {
      value = module.eks_applications.prod_service_name
    }

    output "ingress_name" {
      value = module.eks_applications.ingress_name
    }

    output "ingress_hostname" {
      value = module.eks_applications.ingress_hostname
    }

    output "ingress_address" {
      value = module.eks_applications.ingress_address
    }

    output "fargate_pod_execution_role_arn" {
      value = module.eks_applications.fargate_pod_execution_role_arn
    }
  }
}
