# Create EBS volume for each available AZ
resource "aws_ebs_volume" "volumes" {
  for_each = toset(data.aws_availability_zones.available.names)

  availability_zone = each.value
  size              = var.volume_size
  type              = var.volume_type
  encrypted         = var.encrypted
  kms_key_id        = var.kms_key_id
  iops              = var.volume_type == "gp3" || var.volume_type == "io1" || var.volume_type == "io2" ? var.iops : null
  throughput        = var.volume_type == "gp3" ? var.throughput : null

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-${each.value}"
    AZ   = each.value
  })
}