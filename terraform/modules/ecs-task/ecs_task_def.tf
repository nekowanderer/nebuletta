resource "aws_ecs_task_definition" "beta_task" {
  family                   = local.beta_task_definition_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.beta_container_name
      image = var.beta_container_image

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
          name          = "${var.beta_container_name}-tcp"
          appProtocol   = "http"
        }
      ]

      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${local.beta_task_definition_family}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(local.common_tags, {
    Name = local.beta_task_definition_family
  })
}

resource "aws_cloudwatch_log_group" "beta_task_log_group" {
  name              = "/ecs/${local.beta_task_definition_family}"
  retention_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${local.beta_task_definition_family}-log-group"
  })
}

resource "aws_ecs_task_definition" "prod_task" {
  family                   = local.prod_task_definition_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = var.prod_container_name
      image = var.prod_container_image

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
          name          = "${var.prod_container_name}-tcp"
          appProtocol   = "http"
        }
      ]

      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${local.prod_task_definition_family}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(local.common_tags, {
    Name = local.prod_task_definition_family
  })
}

resource "aws_cloudwatch_log_group" "prod_task_log_group" {
  name              = "/ecs/${local.prod_task_definition_family}"
  retention_in_days = 7

  tags = merge(local.common_tags, {
    Name = "${local.prod_task_definition_family}-log-group"
  })
}
