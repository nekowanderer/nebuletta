stack {
  name        = "cluster"
  description = "EKS cluster core infrastructure"
  id          = "893d8ce1-878d-4a0c-95d8-b655449c3f6a"
  tags = [
    "dev",
    "dev-eks-cluster",
    "eks-lab"
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
        key            = "eks-lab/cluster/terraform.tfstate"
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
    module "eks_cluster" {
      source = "../../../../modules/eks-lab/cluster"
      
      env               = global.env
      aws_region        = global.aws_region
      project           = global.project.name
      module_name       = "eks-cluster"
      managed_by        = global.managed_by
      cluster_name      = "dev-eks-cluster"
      kubernetes_version = "1.33"
      enable_fargate    = true
      fargate_namespaces = ["kube-system", "default"]
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "cluster_name" {
      value = module.eks_cluster.cluster_name
    }

    output "cluster_endpoint" {
      value = module.eks_cluster.cluster_endpoint
    }

    output "cluster_arn" {
      value = module.eks_cluster.cluster_arn
    }

    output "oidc_issuer_url" {
      value = module.eks_cluster.oidc_issuer_url
    }

    output "cluster_security_group_id" {
      value = module.eks_cluster.cluster_security_group_id
    }

    output "cluster_iam_role_arn" {
      value = module.eks_cluster.cluster_iam_role_arn
    }

    output "cluster_version" {
      value = module.eks_cluster.cluster_version
    }

    output "cluster_status" {
      value = module.eks_cluster.cluster_status
    }

    output "cluster_platform_version" {
      value = module.eks_cluster.cluster_platform_version
    }

    output "cluster_certificate_authority_data" {
      value = module.eks_cluster.cluster_certificate_authority_data
    }

    output "fargate_profile_name" {
      value = module.eks_cluster.fargate_profile_name
    }

    output "fargate_profile_arn" {
      value = module.eks_cluster.fargate_profile_arn
    }

    output "fargate_pod_execution_role_arn" {
      value = module.eks_cluster.fargate_pod_execution_role_arn
    }
  }
}
