stack {
  name        = "isolated-ec2"
  description = "Isolated EC2 component"
  id          = "b643e8b5-0e67-42f8-915a-a5056b4da549"
  tags = [
    "dev",
    "infrastructure",
    "isolated-ec2"
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
        key            = "isolated-ec2/terraform.tfstate"
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
    module "isolated-ec2" {
      source = "../../../../../../modules/compute/ec2/private/isolated"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "isolated-ec2"
      managed_by = global.managed_by
      instance_type = "t3.micro"
      ami_id = ""
      key_name = ""
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "ec2_instance_id" {
      value = module.isolated-ec2.ec2_instance_id
    }

    output "ec2_instance_private_ip" {
      value = module.isolated-ec2.ec2_instance_private_ip
    }

    output "ec2_security_group_id" {
      value = module.isolated-ec2.ec2_security_group_id
    }

    output "ec2_iam_role_name" {
      value = module.isolated-ec2.ec2_iam_role_name
    }

    output "ec2_iam_role_arn" {
      value = module.isolated-ec2.ec2_iam_role_arn
    }
  }
}
