stack {
  name        = "default-bastion"
  description = "bastion in default VPC"
  id          = "e318b0be-bc6d-4ca2-ba62-f2e76bac9d3e"
  tags = [
    "dev",
    "dev-default-vpc-bastion"
  ]

  after = [
    "/terraform/stacks/dev/default-vpc"
  ]
}

generate_hcl "_terramate_generated_backend.tf" {
  content {
    terraform {
      backend "s3" {
        bucket         = global.backend.s3.bucket
        key            = "default-vpc-bastion/terraform.tfstate"
        region         = global.aws_region
        encrypt        = true
        dynamodb_table = global.backend.dynamodb.table
      }
    }
  }
}

generate_hcl "_terramate_generated_terraform_remote_state.tf" {
  content {
    data "terraform_remote_state" "default_vpc" {
      backend = "s3"
      config = {
        bucket = global.backend.s3.bucket
        key    = "default-vpc/terraform.tfstate"
        region = global.aws_region
      }
    }
  }
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "default-bastion" {
      source = "../../../../../../modules/compute/ec2/public/default_vpc_bastion"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "default-vpc-bastion"
      managed_by = global.managed_by
      instance_type = "t3.medium"
      ami_id = ""
      default_vpc_id = data.terraform_remote_state.default_vpc.outputs.vpc_id
      default_public_subnet_ids = data.terraform_remote_state.default_vpc.outputs.subnet_ids
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "instance_id" {
      value = module.default-bastion.instance_id
    }

    output "instance_private_ip" {
      value = module.default-bastion.instance_private_ip
    }

    output "instance_public_ip" {
      value = module.default-bastion.instance_public_ip
    }

    output "security_group_id" {
      value = module.default-bastion.security_group_id
    }

    output "iam_role_arn" {
      value = module.default-bastion.iam_role_arn
    }

    output "iam_instance_profile_arn" {
      value = module.default-bastion.iam_instance_profile_arn
    }
  }
}
