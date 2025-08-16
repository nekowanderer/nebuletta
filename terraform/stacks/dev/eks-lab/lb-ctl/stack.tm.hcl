stack {
  name        = "lb-ctl"
  description = "EKS Load Balancer Controller"
  id          = "4a9f6e3c-8d7b-4f5e-a2c1-3b4d5e6f7a8b"
  tags = [
    "dev",
    "dev-eks-lb-ctl",
    "eks-lab"
  ]

  after = [
    "/terraform/stacks/dev/eks-lab/iam-oidc"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "eks-lab/lb-ctl/terraform.tfstate"
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

    data "terraform_remote_state" "eks_iam_oidc" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "eks-lab/iam-oidc/terraform.tfstate"
        region = global.aws_region
      }
    }
  }
}

# Import shared Kubernetes and Helm provider template
import {
  source = "../../shared/terramate-templates/eks-k8s-provider.tm.hcl"
}

generate_hcl "_terramate_generated_helm_provider.tf" {
  content {
    provider "helm" {
      kubernetes {
        host                   = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
        cluster_ca_certificate = base64decode(data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data)
        
        exec {
          api_version = "client.authentication.k8s.io/v1beta1"
          command     = "aws"
          args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks_cluster.outputs.cluster_name, "--region", global.aws_region]
        }
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "eks_lb_ctl" {
      source = "../../../../modules/eks-lab/lb-ctl"
      
      env                                   = global.env
      aws_region                            = global.aws_region
      project                               = global.project.name
      module_name                           = "eks-lb-ctl"
      managed_by                            = global.managed_by
      cluster_name                          = data.terraform_remote_state.eks_cluster.outputs.cluster_name
      oidc_provider_arn                     = data.terraform_remote_state.eks_iam_oidc.outputs.oidc_provider_arn
      load_balancer_controller_policy_arn   = data.terraform_remote_state.eks_iam_oidc.outputs.alb_controller_policy_arn
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "load_balancer_controller_role_arn" {
      value = module.eks_lb_ctl.load_balancer_controller_role_arn
    }

    output "load_balancer_controller_role_name" {
      value = module.eks_lb_ctl.load_balancer_controller_role_name
    }

    output "load_balancer_controller_service_account_name" {
      value = module.eks_lb_ctl.load_balancer_controller_service_account_name
    }

    output "load_balancer_controller_service_account_namespace" {
      value = module.eks_lb_ctl.load_balancer_controller_service_account_namespace
    }

    output "helm_release_name" {
      value = module.eks_lb_ctl.helm_release_name
    }

    output "helm_release_namespace" {
      value = module.eks_lb_ctl.helm_release_namespace
    }

    output "helm_release_status" {
      value = module.eks_lb_ctl.helm_release_status
    }
  }
}
