stack {
  name        = "bastion"
  description = "bastion"
  id          = "f0947757-dfc1-421a-a429-b7ccb4dd0092"
  tags = [
    "dev",
    "infrastructure",
    "bastion"
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
        key            = "bastion/terraform.tfstate"
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
    module "bastion" {
      source = "../../../../../../modules/compute/ec2/public/bastion"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "bastion"
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
      value = module.bastion.instance_id
    }

    output "instance_private_ip" {
      value = module.bastion.instance_private_ip
    }

    output "instance_public_ip" {
      value = module.bastion.instance_public_ip
    }

    output "security_group_id" {
      value = module.bastion.security_group_id
    }

    output "iam_role_arn" {
      value = module.bastion.iam_role_arn
    }

    output "iam_instance_profile_arn" {
      value = module.bastion.iam_instance_profile_arn
    }
  }
}
