output "beta_task_definition_arn" {
  description = "The ARN of the beta task definition"
  value       = aws_ecs_task_definition.beta_task.arn
}

output "beta_task_definition_family" {
  description = "The family of the beta task definition"
  value       = aws_ecs_task_definition.beta_task.family
}

output "beta_task_definition_revision" {
  description = "The revision of the beta task definition"
  value       = aws_ecs_task_definition.beta_task.revision
}

output "prod_task_definition_arn" {
  description = "The ARN of the prod task definition"
  value       = aws_ecs_task_definition.prod_task.arn
}

output "prod_task_definition_family" {
  description = "The family of the prod task definition"
  value       = aws_ecs_task_definition.prod_task.family
}

output "prod_task_definition_revision" {
  description = "The revision of the prod task definition"
  value       = aws_ecs_task_definition.prod_task.revision
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  description = "The name of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.name
}