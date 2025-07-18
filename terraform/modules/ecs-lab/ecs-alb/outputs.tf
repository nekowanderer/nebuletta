output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.app_alb.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.app_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the Application Load Balancer"
  value       = aws_lb.app_alb.zone_id
}

output "target_group_id" {
  description = "The ID of the target group"
  value       = aws_lb_target_group.app_tg.id
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.app_alb_sg.id
}

output "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  value       = aws_lb_listener.app_alb_listener.arn
}
