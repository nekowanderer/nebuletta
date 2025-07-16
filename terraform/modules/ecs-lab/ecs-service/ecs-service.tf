# Beta Service Target Group
resource "aws_lb_target_group" "beta_tg" {
  name        = "my-tg-beta"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-beta-tg"
  })
}

# Beta Service Listener Rule
resource "aws_lb_listener_rule" "beta_rule" {
  listener_arn = var.alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.beta_tg.arn
  }

  condition {
    path_pattern {
      values = ["/beta*"]
    }
  }
}

# Beta ECS Service
resource "aws_ecs_service" "beta_service" {
  name             = "my-service-beta"
  cluster          = var.cluster_arn
  task_definition  = "${var.beta_task_definition_family}:${var.beta_task_definition_revision}"
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.beta_tg.arn
    container_name   = "my-container-beta"
    container_port   = 80
  }

  depends_on = [aws_lb_listener_rule.beta_rule]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-beta-service"
  })
}

# Beta Service Auto Scaling Target
resource "aws_appautoscaling_target" "beta_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.beta_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Beta Service Auto Scaling Policy
resource "aws_appautoscaling_policy" "beta_cpu_policy" {
  name               = "cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.beta_target.resource_id
  scalable_dimension = aws_appautoscaling_target.beta_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.beta_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 20.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

# Prod Service Target Group
resource "aws_lb_target_group" "prod_tg" {
  name        = "my-tg-prod"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-prod-tg"
  })
}

# Prod Service Listener Rule
resource "aws_lb_listener_rule" "prod_rule" {
  listener_arn = var.alb_listener_arn
  priority     = 30

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_tg.arn
  }

  condition {
    path_pattern {
      values = ["/prod*"]
    }
  }
}

# Prod ECS Service
resource "aws_ecs_service" "prod_service" {
  name             = "my-service-prod"
  cluster          = var.cluster_arn
  task_definition  = "${var.prod_task_definition_family}:${var.prod_task_definition_revision}"
  desired_count    = 3
  launch_type      = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.prod_tg.arn
    container_name   = "my-container-prod"
    container_port   = 80
  }

  depends_on = [aws_lb_listener_rule.prod_rule]

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-prod-service"
  })
}

# Prod Service Auto Scaling Target
resource "aws_appautoscaling_target" "prod_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.prod_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Prod Service Auto Scaling Policy
resource "aws_appautoscaling_policy" "prod_cpu_policy" {
  name               = "cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.prod_target.resource_id
  scalable_dimension = aws_appautoscaling_target.prod_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.prod_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 20.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
