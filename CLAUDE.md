# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Nebuletta is an experimental Infrastructure-as-Code (IaC) project that uses Terraform and Terramate to rapidly provision self-managed cloud infrastructure on AWS.

## Core Tools and Versions

- **Terraform**: >= 1.11.4
- **Terramate**: >= 0.13.1  
- **AWS CLI**: >= 2.27.16
- **AWS Provider**: ~> 6.3
- **Random Provider**: ~> 3.1.0

## Project Architecture

### Directory Structure
```
.
│──scripts/
│  ├── ssm_user_setup.sh      # SSM user setup script
│  └── terraform_cleanup.sh   # Terraform cleanup script
│   
└──terraform/
    ├── keycloak_cluster/       # Keycloak cluster configuration
    │   └── foundation/
    ├── modules/               # Reusable Terraform modules
    │   ├── compute/          # Compute resources
    │   │   ├── ec2/          # EC2 instances
    │   │   │   ├── private/  # Private EC2
    │   │   │   │   ├── dev/
    │   │   │   │   └── isolated/
    │   │   │   └── public/   # Public EC2
    │   │   │       ├── bastion/
    │   │   │       ├── default_vpc_bastion/
    │   │   │       └── eks-admin/
    │   │   └── fargate/      # Fargate services
    │   │       ├── service/
    │   │       └── task/
    │   ├── default-vpc/      # Default VPC resources
    │   ├── networking/       # VPC, subnets, route tables, and other network resources
    │   ├── random-id-generator/ # Random ID generator
    │   ├── s3/              # S3 storage resources
    │   │   ├── archive-bucket/
    │   │   └── general-bucket/
    │   └── state-storage/    # Terraform state storage
    └── stacks/              # Terramate stacks for different environments
        ├── dev/             # Development environment
        │   ├── compute/
        │   │   └── ec2/
        │   │       ├── private/
        │   │       └── public/
        │   ├── default-vpc/
        │   ├── networking/
        │   ├── s3/
        │   └── state-storage/
        └── random-id-generator/
```

### Terramate Configuration
- Global configuration located at `terraform/terramate.tm.hcl`
- Environment-specific configuration located at `terraform/stacks/dev/terramate.tm.hcl`
- Default AWS region: ap-northeast-1
- State storage uses S3 + DynamoDB locking mechanism

## Common Commands

### Basic Terramate Operations
```bash
# List all stacks
terramate list

# Create new stack
terramate create path/to/stack

# Generate Terraform files
terramate generate

# Initialize project
terramate run --tags networking -- terraform init

# Plan specific stack (using networking as example)
terramate run --tags networking -- terraform plan

# Apply specific stack
terramate run --tags networking -- terraform apply

# Destroy specific stack
terramate run --tags networking -- terraform destroy
```

### Cleanup Scripts
```bash
# Clean up all Terraform-generated files
./scripts/terraform_cleanup.sh

# Setup SSM user environment, this is only for executing inside the EC2 instance
./scripts/ssm_user_setup.sh
```

## Module Development Guidelines

### Naming Conventions
- Resource prefix: `${env}-${module_name}`
- Tag structure: Environment, Project, ModuleName, Name, ManagedBy

### Module Structure
Each module contains:
- `main.tf` - Provider configuration
- `locals.tf` - Local variables and common tags
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `common.tfvars` - Common variable values

### Stack Structure
Each stack contains:
- `stack.tm.hcl` - Terramate stack configuration
- Auto-generated `_terramate_generated_*.tf` files

## Important Notes

1. **Version Control Requirements**: Ensure there are no uncommitted changes before running `terramate init/plan/apply`
2. **State Management**: Uses S3 + DynamoDB for remote state management
3. **Tagging Strategy**: All resources use a unified tagging architecture for management
4. **Region Configuration**: Defaults to ap-northeast-1, adjustable via global variables

## Development Workflow

1. Develop reusable modules under `terraform/modules/`
2. Create environment-specific stacks under `terraform/stacks/`
3. Use `terramate generate` to generate necessary Terraform files
4. Use tag system to manage deployment of specific modules
5. Use cleanup scripts to clean development environment

## Available Modules

### Compute Resources
- `compute/ec2/private/isolated` - Isolated private EC2
- `compute/ec2/public/bastion` - Bastion host
- `compute/ec2/public/default_vpc_bastion` - Default VPC bastion host
- `compute/ec2/public/eks-admin` - EKS management server

### Storage Resources
- `s3/archive-bucket` - Archive storage bucket
- `s3/general-bucket` - General purpose bucket

### Network Resources
- `networking` - VPC, subnets, route tables, NAT gateways, etc.
- `default-vpc` - Default VPC resources

### Infrastructure
- `state-storage` - Terraform state storage (S3 + DynamoDB)
- `random-id-generator` - Random ID generator
