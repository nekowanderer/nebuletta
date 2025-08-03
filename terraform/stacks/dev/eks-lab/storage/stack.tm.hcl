stack {
  name        = "storage"
  description = "EKS EFS storage and CSI driver"
  id          = "3f7e8a2d-5c4b-4a3e-9d8f-1a2b3c4d5e6f"
  tags = [
    "dev",
    "dev-eks-storage",
    "eks-lab"
  ]

  after = [
    "/terraform/stacks/dev/eks-lab/cluster"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "eks-lab/storage/terraform.tfstate"
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
  }
}

# Import shared Kubernetes provider template
import {
  source = "../../shared/terramate-templates/eks-k8s-provider.tm.hcl"
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "eks_storage" {
      source = "../../../../modules/eks-lab/storage"
      
      env               = global.env
      aws_region        = global.aws_region
      project           = global.project.name
      module_name       = "eks-storage"
      managed_by        = global.managed_by
      cluster_name      = data.terraform_remote_state.eks_cluster.outputs.cluster_name
      efs_pv_capacity   = "20Gi"
      efs_pvc_request   = "10Gi"
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "efs_id" {
      value = module.eks_storage.efs_id
    }

    output "efs_arn" {
      value = module.eks_storage.efs_arn
    }

    output "efs_dns_name" {
      value = module.eks_storage.efs_dns_name
    }

    output "efs_security_group_id" {
      value = module.eks_storage.efs_security_group_id
    }

    output "efs_access_point_id" {
      value = module.eks_storage.efs_access_point_id
    }

    output "efs_access_point_arn" {
      value = module.eks_storage.efs_access_point_arn
    }

    output "efs_static_pv_name" {
      value = module.eks_storage.efs_static_pv_name
    }

    output "efs_pvc_name" {
      value = module.eks_storage.efs_pvc_name
    }

    output "static_storage_class_name" {
      value = module.eks_storage.static_storage_class_name
    }
  }
}
