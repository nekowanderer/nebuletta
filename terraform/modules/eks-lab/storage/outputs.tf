# Output value definitions

output "efs_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.eks.id
}

output "efs_arn" {
  description = "EFS file system ARN"
  value       = aws_efs_file_system.eks.arn
}

output "efs_dns_name" {
  description = "EFS file system DNS name"
  value       = aws_efs_file_system.eks.dns_name
}

output "efs_security_group_id" {
  description = "EFS security group ID"
  value       = aws_security_group.efs.id
}

output "efs_access_point_id" {
  description = "EFS access point ID"
  value       = aws_efs_access_point.eks.id
}

output "efs_access_point_arn" {
  description = "EFS access point ARN"
  value       = aws_efs_access_point.eks.arn
}

output "efs_static_pv_name" {
  description = "EFS static persistent volume name"
  value       = kubernetes_persistent_volume.efs_static_pv.metadata[0].name
}

output "efs_pvc_name" {
  description = "EFS persistent volume claim name"
  value       = kubernetes_persistent_volume_claim.efs_pvc.metadata[0].name
}

output "static_storage_class_name" {
  description = "Static storage class name for EFS volumes"
  value       = "efs-static"
}
