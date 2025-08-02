# Output value definitions

output "oidc_provider_arn" {
  description = "ARN of the OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC Identity Provider"
  value       = aws_iam_openid_connect_provider.eks.url
}

output "alb_controller_policy_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM policy"
  value       = aws_iam_policy.alb_controller.arn
}

output "alb_controller_policy_name" {
  description = "Name of the AWS Load Balancer Controller IAM policy"
  value       = aws_iam_policy.alb_controller.name
}
