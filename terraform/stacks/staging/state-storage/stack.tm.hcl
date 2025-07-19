stack {
  name        = "state-storage"
  description = "state-storage"
  id          = "749a990b-788b-426b-98d3-64183ec23ae2"
  tags = [
    "staging-state-storage"
  ]
}

generate_hcl "_terramate_generated_main.tf" {
  content {
    module "state_storage" {
      source = "git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/state-storage?ref=v4.0.0"
      env     = global.env
      aws_region = global.aws_region
      project = global.project.name
      module_name = "state-storage"
      managed_by = global.managed_by
    }
  }
}

generate_hcl "_terramate_generated_outputs.tf" {
  content {
    output "state_bucket_name" {
      value = module.state_storage.storage_name
    }

    output "state_bucket_arn" {
      value = module.state_storage.storage_arn
    }

    output "state_dynamodb_table" {
      value = module.state_storage.lock_table_name
    }

    output "state_lock_table_arn" {
      value = module.state_storage.lock_table_arn
    }

    output "kms_key_id" {
      value = module.state_storage.kms_key_id
    }

    output "kms_key_arn" {
      value = module.state_storage.kms_key_arn
    }

    output "kms_key_alias" {
      value = module.state_storage.kms_key_alias
    }

    output "kms_key_policy" {
      value = module.state_storage.kms_key_policy
    }
  }
}
