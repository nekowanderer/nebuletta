output "volume_ids" {
  description = "Map of AZ to EBS volume IDs"
  value       = { for k, v in aws_ebs_volume.volumes : k => v.id }
}

output "volume_arns" {
  description = "Map of AZ to EBS volume ARNs"
  value       = { for k, v in aws_ebs_volume.volumes : k => v.arn }
}

output "volume_sizes" {
  description = "Map of AZ to EBS volume sizes"
  value       = { for k, v in aws_ebs_volume.volumes : k => v.size }
}

output "availability_zones" {
  description = "List of availability zones where volumes were created"
  value       = keys(aws_ebs_volume.volumes)
}

output "volumes_info" {
  description = "Complete information about all created volumes"
  value = {
    for k, v in aws_ebs_volume.volumes : k => {
      id                = v.id
      arn               = v.arn
      size              = v.size
      type              = v.type
      availability_zone = v.availability_zone
      encrypted         = v.encrypted
      kms_key_id        = v.kms_key_id
    }
  }
}
