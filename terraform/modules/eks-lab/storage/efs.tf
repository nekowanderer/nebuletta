# Create EFS file system and security group

# Validate VPC configuration
resource "null_resource" "vpc_config_validation" {
  count = local.vpc_config_valid ? 0 : 1

  provisioner "local-exec" {
    command = "echo 'Error: Invalid VPC configuration. Please ensure networking module is deployed and vpc_config is properly configured.' && exit 1"
  }
}

# Security Group for EFS
resource "aws_security_group" "efs" {
  name        = "${local.prefix}-efs-sg"
  description = "Security group for EFS file system"
  vpc_id      = local.vpc_config_from_remote.vpc_id

  ingress {
    description = "NFS from EKS nodes"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.infra_networking.outputs.vpc_cidr]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-efs-sg"
  })

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [null_resource.vpc_config_validation]
}

# EFS File System
resource "aws_efs_file_system" "eks" {
  creation_token   = "${local.prefix}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  encrypted = true

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-efs"
  })

  lifecycle {
    create_before_destroy = false
  }
}

# EFS Mount Targets in each private subnet
resource "aws_efs_mount_target" "eks" {
  count = length(local.vpc_config_from_remote.private_subnet_ids)

  file_system_id  = aws_efs_file_system.eks.id
  subnet_id       = local.vpc_config_from_remote.private_subnet_ids[count.index]
  security_groups = [aws_security_group.efs.id]
}

# EFS Access Point for application use
resource "aws_efs_access_point" "eks" {
  file_system_id = aws_efs_file_system.eks.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/app"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "0755"
    }
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-efs-access-point"
  })
}
