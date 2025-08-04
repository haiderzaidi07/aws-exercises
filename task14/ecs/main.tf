resource "aws_ecs_cluster" "haider-tf-cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "haider-tf-td-nginx" {
  family                   = var.task_definition_family
  execution_role_arn       = var.task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${var.container_image}"
      essential = true
      cpu       = 512
      memory    = 1024
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.task_definition_family}"
          awslogs-create-group  = "true"
          awslogs-region        = "us-east-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_ecs_service" "haider-tf-ecs-service" {
  name             = var.cluster_name
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  desired_count    = var.tasks_count
  cluster          = aws_ecs_cluster.haider-tf-cluster.id
  task_definition  = aws_ecs_task_definition.haider-tf-td-nginx.arn

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }
}