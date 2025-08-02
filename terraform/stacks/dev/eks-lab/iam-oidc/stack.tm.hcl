stack {
  name        = "iam-oidc"
  description = "EKS IAM OIDC Provider and policies"
  id          = "acf5983d-f7ca-4543-8d85-be33c20d2087"
  tags = [
    "dev",
    "dev-eks-iam-oidc",
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
        key            = "eks-lab/iam-oidc/terraform.tfstate"
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
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "eks_iam_oidc" {
      source = "../../../../modules/eks-lab/iam-oidc"
      
      env               = global.env
      aws_region        = global.aws_region
      project           = global.project.name
      module_name       = "eks-iam-oidc"
      managed_by        = global.managed_by
      cluster_name      = data.terraform_remote_state.eks_cluster.outputs.cluster_name
      oidc_issuer_url   = data.terraform_remote_state.eks_cluster.outputs.oidc_issuer_url
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "oidc_provider_arn" {
      value = module.eks_iam_oidc.oidc_provider_arn
    }

    output "oidc_provider_url" {
      value = module.eks_iam_oidc.oidc_provider_url
    }

    output "alb_controller_policy_arn" {
      value = module.eks_iam_oidc.alb_controller_policy_arn
    }

    output "alb_controller_policy_name" {
      value = module.eks_iam_oidc.alb_controller_policy_name
    }
  }
}
