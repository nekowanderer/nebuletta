#!/bin/bash

# =============================================
# Terraform Cleanup Script
# =============================================
# This script will remove the following files:
# 1. All .terraform directories (including downloaded providers and modules)
# 2. All terraform.tfstate files (Terraform state files)
# 3. All _terramate_generated*.tf files (Terramate generated files)
# 4. All .terraform.lock.hcl files (provider version lock files)
#
# ⚠️ WARNING: This script will delete all Terraform state files
# Please ensure you have:
# 1. Backed up important state files
# 2. Verified that cloud resources have been properly cleaned up
# 3. Understood the consequences of running this script
# =============================================

echo "⚠️ WARNING: This script will delete all Terraform state files"
echo "Please ensure you have backed up important data and cloud resources have been properly cleaned up"
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Operation cancelled"
    exit 1
fi

echo "Starting Terraform cleanup..."

# Find and remove all .terraform directories
find ../terraform -type d -name ".terraform" -exec rm -rf {} +

# Find and remove all terraform.tfstate files
find ../terraform -type f -name "terraform.tfstate" -delete

# Find and remove all _terramate_generated*.tf files
find ../terraform -type f -name "_terramate_generated*.tf" -delete

# Find and remove all .terraform.lock.hcl files
find ../terraform -type f -name ".terraform.lock.hcl" -delete

echo "Cleanup completed!" 
