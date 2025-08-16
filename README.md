# Project Nebuletta

> _The seed of a cloud-borne civilization,  
> shaped in code, summoned into existence._

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
  - [Required Tools](#required-tools)
  - [Required Providers](#required-providers)
  - [Required Access](#required-access)
- [Project Structure](#project-structure)
- [Remote Module Versioning](#remote-module-versioning)
  - [Environment-Specific Module Strategy](#environment-specific-module-strategy)
  - [Version Control Workflow](#version-control-workflow)
  - [Module Source Configuration](#module-source-configuration)
- [Initialize the State Storage](#initialize-the-state-storage)
- [Recommended Development Workflow](#recommended-development-workflow)
- [Basic Commands](#basic-commands)
  - [List Stacks](#list-stacks)
  - [Code Quality Checks](#code-quality-checks)
  - [Create a new stack](#create-a-new-stack)
  - [Generate .tf Files for Stacks](#generate-tf-files-for-stacks)
  - [Initialize the Project](#initialize-the-project)
  - [Plan a Specific Stack](#plan-a-specific-stack)
  - [Apply a Specific Stack](#apply-a-specific-stack)
  - [Destroy a Specific Stack](#destroy-a-specific-stack)
  - [Upgrade Terraform AWS Provider](#upgrade-terraform-aws-provider)
  - [Setup Terminal and Related CLI Tools for EC2 SSM User](#setup-terminal-and-related-cli-tools-for-ec2-ssm-user)

## Introduction

**Nebuletta** is an experimental Infrastructure-as-Code (IaC) project designed to rapidly provision self-managed cloud infrastructure using [Terraform](https://www.terraform.io/) on public cloud platforms.

This project is built with **AWS** as the default cloud provider. It includes a set of composable, self-contained modules that can be flexibly assembled based on different deployment scenarios.

To manage orchestration, **[Terramate](https://terramate.io/)** is used instead of introducing additional domain-specific frameworks like Terragrunt. This choice keeps the entire infrastructure stack purely in Terraform's native language, ensuring simplicity and consistency.
  
The project documentation is maintained in a separate repository, [click here to view the documentation](https://github.com/nekowanderer/nebuletta-notes).

## Prerequisites

### Required Tools
- AWS CLI (>= `2.27.16`) installed on your local machine
- Terraform (>= `1.11.4`)
- Terramate (>= `0.13.1`)

### Required Providers
- AWS Provider (~> `6.3`)
- Random Provider (~> `3.1.0`)

### Required Access
- An AWS account with sufficient permissions/roles/policies for executing the tasks defined in the Terraform scripts.

## Project Structure

```bash
.
├── scripts
│   ├── ssm_user_setup.sh
│   └── terraform_cleanup.sh
└── terraform
    ├── modules
    │   ├── networking
    │   ├── ...
    │   └── state-storage
    └── stacks
        └── dev
            ├── networking
            ├── ...
            └── state-storage
```

| Directory | Purpose | Description |
|-----------|---------|-------------|
| `scripts/` | Utility Scripts | Contains project maintenance and setup related script files |
| `terraform/modules/` | Terraform Modules | Reusable infrastructure components that provide standardized resource configurations |
| `terraform/stacks/` | Terramate Stacks | Environment-specific configurations such as `dev`/`staging`/`production` |

You can compose the stack according to your requirements by adding different subfolders under the specific stack folder and writing the appropriate `stack.tm.hcl` file for each module.

## Remote Module Versioning

This project implements a sophisticated module versioning strategy using Git remote modules, enabling environment-specific deployment approaches while maintaining code consistency and stability.

### Environment-Specific Module Strategy

**Development Environment (`dev`)**:
- Uses **local modules** for rapid development and testing
- Source: e.g., `"../../../modules/<module-name>"`
- Allows immediate code changes without version management overhead
- Perfect for active development and experimentation

**Staging/Production Environments (`staging`, `prod`)**:
- Uses **Git remote modules** with version pinning
- Source: `"git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/<module-name>?ref=<version>"`
- Ensures consistent, tested infrastructure deployments
- Prevents unintended changes from affecting stable environments

### Version Control Workflow

#### 1. Development Phase
```hcl
# terraform/stacks/dev/<module>/stack.tm.hcl
generate_hcl "_terramate_generated_main.tf" {
  content {
    module "<module_name>" {
      source = "../../../modules/<module-name>"
      # ... other configuration
    }
  }
}
```

#### 2. Release Phase
```bash
# Create and push version tag
$ git tag v1.0.0
$ git push origin v1.0.0
```

#### 3. Staging/Production Deployment
```hcl
# terraform/stacks/staging/<module>/stack.tm.hcl
generate_hcl "_terramate_generated_main.tf" {
  content {
    module "<module_name>" {
      source = "git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/<module-name>?ref=v1.0.0"
      # ... other configuration
    }
  }
}
```

### Module Source Configuration

#### Git Remote Module URL Format
```
git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/<module-name>?ref=<version>
```

**Components:**
- `git::ssh://` - Protocol specification
- `git@github.com/nekowanderer/nebuletta.git` - Repository URL
- `//terraform/modules/<module-name>` - Path to module within repository
- `?ref=<version>` - Git reference (tag, branch, or commit hash)

#### Environment Configuration Examples

**Development Environment:**
```hcl
module "networking" {
  source = "../../../modules/networking"
  vpc_cidr = "10.0.0.0/16"
  # ... other variables
}
```

**Staging Environment:**
```hcl
module "networking" {
  source = "git::ssh://git@github.com/nekowanderer/nebuletta.git//terraform/modules/networking?ref=v4.0.0"
  vpc_cidr = "10.1.0.0/16"  # Different CIDR to avoid conflicts
  # ... other variables
}
```

**Benefits:**
- **Version Locking**: Staging/production environments use stable, tested versions
- **Development Speed**: Local modules enable rapid iteration
- **Environment Isolation**: Different VPC CIDRs and configurations per environment
- **Module Reusability**: Same modules across environments with different configurations
- **Controlled Upgrades**: Explicit version upgrades through git tags

## Initialize the State Storage
- For every Terraform module, we need to provide state storage to maintain the infrastructure state and ensure consistency across team collaboration.
- The state storage module doesn't use a remote backend since it creates the foundational infrastructure for all other Terraform modules. This solves the classic "chicken and egg" problem in Terraform infrastructure: you need the S3 bucket and DynamoDB table to exist before other modules can use them as remote backends.
- The following table describes the purpose of each component of the state storage in this project:
  | Component | Purpose | Features | Naming Convention |
  |-----------|---------|----------|-------------------|
  | **S3 Bucket** | Stores Terraform state files (`.tfstate`) | Versioning enabled, encryption at rest, cross-region replication support | `<env>-state-storage-s3` |
  | **DynamoDB Table** | Provides state locking mechanism to prevent concurrent modifications | Stores lock information with TTL, prevents race conditions | `<env>-state-storage-locks` |
  | **KMS Key** | Encrypts state files stored in S3 for enhanced security | Customer-managed encryption, access control via IAM policies | `<env>-state-storage-key` |

- To achieve this, first navigate to `terraform/modules/state-storage`, where you'll need to adjust some parameters to create the storage in your AWS environment.
- Prerequisites:
  - **common.tfvars**
    - Update all input variables according to your requirements. If you plan to set up infrastructure via Terramate, you can leave the defaults.
  - **kms.tf**
    - Update the principal of `AllowSSOUserAccess` inside the `aws_kms_key_policy`.
    - If you're not using AWS SSO users, please adjust it according to the Terraform official document.
- **For Terraform module style**
  ```bash
  # Navigate to terraform/modules/state-storage

  $ terraform init

  $ terraform plan -var-file="common.tfvars"

  $ terraform apply -var-file="common.tfvars"

  # Then you should be able to see the related components in the AWS console
  ```
  - You can take this [PR](https://github.com/nekowanderer/nebuletta/pull/3) as the example.

- **For Terramate stack style**
  ```bash
  # Navigate to terraform/stacks/state-storage

  $ terramate generate

  $ terramate run --tags dev-state-storage -- terraform init

  $ terramate run --tags dev-state-storage -- terraform plan

  $ terramate run --tags dev-state-storage -- terraform apply

  $ terramate run --tags dev-state-storage -- terraform destroy

  # Skip approval prompt 
  $ terramate run --tags dev-state-storage -- terraform apply -auto-approve

  $ terramate run --tags dev-state-storage -- terraform destroy -auto-approve

  # Then you should be able to see the related components in the AWS console
  ```

## Recommended Development Workflow
```bash
# 1. Format source code in modules
$ cd terraform/modules/<module-name>
$ terraform fmt

# 2. Generate the terramate stack
$ terramate create path/to/stack

# 3. Write the stack.tm.hcl for the stack
$ vi path_to_stack/stack.tm.hcl

# 4. Generate Terramate files
$ terramate generate

# 5. Validate complete configuration
$ terramate run --tags <tag> -- terraform validate

# 6. Init the stack
$ terramate run --tags <tag> -- terraform init

# 7. Plan changes
$ terramate run --tags <tag> -- terraform plan

# 8. Apply changes
$ terramate run --tags <tag> -- terraform apply
```

## Basic Commands

### List Stacks
Navigate to the project root and execute:
```bash
$ terramate list
```
This will show you the stacks that exist in this project.

### Code Quality Checks
Before deploying infrastructure, it's recommended to run these commands to ensure code quality:

#### Architecture-Specific Workflow
In this project, Terraform modules under `terraform/modules/` contain raw source code that serves as reusable components. These modules are not intended to be executed directly as infrastructure deployments. Instead, Terramate generates the actual executable Terraform files in the `terraform/stacks/` directories for environment-specific deployments.

**Due to this architecture:**

1. **Format checking** can be performed in both locations:
   - **Module level**: `terraform fmt -check` (for source code formatting)
   - **Stack level**: `terramate run --tags <tag> -- terraform fmt -check` (for generated deployment files)

2. **Syntax validation** must be performed at the stack level only:
   - **Module level validation will fail** because modules lack provider configurations and complete context
   - **Stack level validation is required**: `terramate run --tags <tag> -- terraform validate`
   - This is because only the generated stack files contain the complete provider configurations, variable definitions, and deployment context necessary for proper validation

#### Format Check
```bash
# Format source code in modules
$ cd terraform/modules/<module-name>
$ terraform fmt

# Check formatting via Terramate (for generated files)
$ terramate run --tags <tag> -- terraform fmt -check
```

#### Syntax Validation
```bash
# If validate under the module folder (take module/networking as example):
$ terraform validate
╷
│ Error: Missing required provider
│
│ This configuration requires provider registry.terraform.io/hashicorp/aws, but that provider isn't available. You may be able to install it automatically by running:
│   terraform init
╵
╷
│ Error: Missing required provider
│
│ This configuration requires provider registry.terraform.io/hashicorp/null, but that provider isn't available. You may be able to install it automatically by running:
│   terraform init
╵

# Validate complete configuration via Terramate
$ terramate run --tags <tag> -- terraform validate
```

### Create a new stack
Please adjust the path in the following command according to your current path:
```bash
$ terramate create path/to/stack
```
This will help to generate the `stack.tm.hcl` with dedicated UUID under the created stack folder.

### Generate .tf Files for Stacks
Navigate to the project root and execute:
```bash
$ terramate generate
```
This will generate all the Terraform files defined in the stack.tm.hcl for each stack.

### Initialize the Project
Navigate to the project root or the specific stack you would like to initialize, and execute:
```bash
$ terramate run --tags networking -- terraform init
```

⚠️ **Warning**: For init/plan/apply via Terramate, ensure you don't have any unstaged changes in your version control system (like Git). Otherwise, you'll see a message like:

```
On branch xxx
Your branch is up to date with 'origin/xxx'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   unstaged_file
```

For this situation, please stage/commit the changes first before continuing.

### Plan a Specific Stack
It's a good practice to plan stacks by tags. For example, to plan the networking module, execute the following command under the project root:
```bash
$ terramate run --tags networking -- terraform plan
```
This is equivalent to performing the `terraform plan` command under the networking module independently.

### Apply a Specific Stack
Similar to the plan command, to apply the networking module, execute the following command under the project root:
```bash
$ terramate run --tags networking -- terraform apply

# Auto approve (be careful when using this)
$ terramate run --tags networking -- terraform apply -auto-approve
```
This is equivalent to performing the `terraform apply` command under the networking module independently.

You'll then see the following message in the terminal:
```bash
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Type `yes` if you're sure all the planned resources meet your requirements. Otherwise, cancel the apply operation by typing any other word and adjust the script.

After the apply operation, check the message which should look like:
```bash
Apply complete! Resources: xx added, 0 changed, 0 destroyed.

Outputs:

...
...
...
```

Verify that all resources are arranged as desired.

### Destroy a Specific Stack
Again, using the networking module as an example, to destroy it, execute:
```bash
$ terramate run --tags networking -- terraform destroy
```
This is equivalent to performing the `terraform destroy` command under the networking module independently.

Like the apply operation, it will prompt for confirmation before destroying the specified resources. Type `yes` if you have carefully reviewed the details.

After the destroy operation, check the message and log into your public cloud interface (like AWS Console) to double-check the resource allocation status.

### Upgrade Terraform AWS Provider
Once you upgrade the aws terraform provider, make sure to:
```bash
# Make sure to regenerate the .tf file
$ terramate generate

# Then, update the modules by specifying target tags
$ terramate run --tags dev -- terraform init -upgrade
```

### Setup Terminal and Related CLI Tools for EC2 SSM User
- Please copy the content of [ssm_user_setup.sh](./scripts/ssm_user_setup.sh) and save it to a `.sh` file under the home directory of the `ssm-user` once you launch the EC2 instance. 
- Then configure the variables in the `Configurations` section of the script.
- Now you're ready to go, the commands are listed below:
  ```bash
  $ vi ssm_user_setup.sh

  $ chmod +x ssm_user_setup.sh
  
  $ ./ssm_user_setup.sh
  ```
- After the setup, you can also replace the content of `~/.zshrc` with [custom_zshrc](/scripts/custom_zshrc), which already contains most of the configurations for practicing the EKS.
