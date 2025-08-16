stack {
  name        = "hpa"
  description = "EKS HPA (Horizontal Pod Autoscaler) and Metrics Server validation"
  id          = "f8e7d6c5-b4a3-4f2e-9c8b-7a6d5e4f3c2b"
  tags = [
    "dev",
    "dev-eks-hpa",
    "eks-lab"
  ]

  after = [
    "/terraform/stacks/dev/eks-lab/applications"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "eks-lab/hpa/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_terraform_remote_state.tf" {
  content {
    data "terraform_remote_state" "eks_cluster" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "eks-lab/cluster/terraform.tfstate"
        region = global.aws_region
      }
    }

    data "terraform_remote_state" "eks_applications" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "eks-lab/applications/terraform.tfstate"
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
    module "eks_hpa" {
      source = "../../../../modules/eks-lab/hpa"
      
      env           = global.env
      aws_region    = global.aws_region
      project       = global.project.name
      module_name   = "eks-hpa"
      managed_by    = global.managed_by
      state_storage = global.backend.s3.bucket
      cluster_name  = data.terraform_remote_state.eks_cluster.outputs.cluster_name

      # HPA configuration
      hpa_target_namespace = data.terraform_remote_state.eks_applications.outputs.app_namespace

      # Beta app HPA settings
      enable_beta_hpa                = true
      beta_hpa_cpu_target_percentage = 10
      beta_hpa_min_replicas          = 1
      beta_hpa_max_replicas          = 10

      # Production app HPA settings
      enable_prod_hpa                = true
      prod_hpa_cpu_target_percentage = 70
      prod_hpa_min_replicas          = 3
      prod_hpa_max_replicas          = 20
      
      # Metrics Server version
      metrics_server_version      = "3.12.1"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    # Metrics Server outputs
    output "metrics_server_deployment_name" {
      value = module.eks_hpa.metrics_server_deployment_name
    }

    output "metrics_server_namespace" {
      value = module.eks_hpa.metrics_server_namespace
    }

    output "metrics_server_addon_version" {
      value = module.eks_hpa.metrics_server_addon_version
    }

    output "metrics_server_status" {
      value = module.eks_hpa.metrics_server_status
    }

    # HPA configuration outputs
    output "hpa_target_namespace" {
      value = module.eks_hpa.hpa_target_namespace
    }

    output "beta_hpa_enabled" {
      value = module.eks_hpa.beta_hpa_enabled
    }

    output "prod_hpa_enabled" {
      value = module.eks_hpa.prod_hpa_enabled
    }

    # Beta HPA outputs
    output "beta_hpa_name" {
      value = module.eks_hpa.beta_hpa_name
    }

    output "beta_hpa_cpu_target_percentage" {
      value = module.eks_hpa.beta_hpa_cpu_target_percentage
    }

    output "beta_hpa_min_replicas" {
      value = module.eks_hpa.beta_hpa_min_replicas
    }

    output "beta_hpa_max_replicas" {
      value = module.eks_hpa.beta_hpa_max_replicas
    }

    # Production HPA outputs
    output "prod_hpa_name" {
      value = module.eks_hpa.prod_hpa_name
    }

    output "prod_hpa_cpu_target_percentage" {
      value = module.eks_hpa.prod_hpa_cpu_target_percentage
    }

    output "prod_hpa_min_replicas" {
      value = module.eks_hpa.prod_hpa_min_replicas
    }

    output "prod_hpa_max_replicas" {
      value = module.eks_hpa.prod_hpa_max_replicas
    }

    # HPA status outputs
    output "beta_hpa_status" {
      value = module.eks_hpa.beta_hpa_status
    }

    output "prod_hpa_status" {
      value = module.eks_hpa.prod_hpa_status
    }
  }
}
