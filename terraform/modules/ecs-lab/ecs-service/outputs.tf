output "beta_service_id" {
  description = "The ID of the beta ECS service"
  value       = aws_ecs_service.beta_service.id
}

output "beta_service_name" {
  description = "The name of the beta ECS service"
  value       = aws_ecs_service.beta_service.name
}

output "beta_target_group_arn" {
  description = "The ARN of the beta target group"
  value       = aws_lb_target_group.beta_tg.arn
}

output "prod_service_id" {
  description = "The ID of the prod ECS service"
  value       = aws_ecs_service.prod_service.id
}

output "prod_service_name" {
  description = "The name of the prod ECS service"
  value       = aws_ecs_service.prod_service.name
}

output "prod_target_group_arn" {
  description = "The ARN of the prod target group"
  value       = aws_lb_target_group.prod_tg.arn
}
