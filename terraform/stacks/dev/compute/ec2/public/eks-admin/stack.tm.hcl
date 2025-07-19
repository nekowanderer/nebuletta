stack {
  name        = "eks-admin"
  description = "eks-admin ec2"
  id          = "19600efc-14fa-4456-9e8a-8607ab04842d"
  tags = [
    "dev",
    "dev-eks-admin"
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
        key            = "eks-admin/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_terraform_remote_state.tf" {
  content {
    data "terraform_remote_state" "networking" {
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
    module "eks-admin" {
      source = "../../../../../../modules/compute/ec2/public/eks-admin"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "eks-admin-ec2"
      managed_by = global.managed_by
      instance_type = "t3.medium"
      ami_id = ""
      vpc_id = data.terraform_remote_state.networking.outputs.vpc_id
      public_subnet_ids = data.terraform_remote_state.networking.outputs.public_subnet_ids
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "instance_id" {
      value = module.eks-admin.instance_id
    }

    output "instance_private_ip" {
      value = module.eks-admin.instance_private_ip
    }

    output "instance_public_ip" {
      value = module.eks-admin.instance_public_ip
    }

    output "security_group_id" {
      value = module.eks-admin.security_group_id
    }

    output "iam_role_arn" {
      value = module.eks-admin.iam_role_arn
    }

    output "iam_instance_profile_arn" {
      value = module.eks-admin.iam_instance_profile_arn
    }
  }
}
