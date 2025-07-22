resource "aws_ecs_capacity_provider" "haider-tf-ec2-capacity-provider" {
  name = "haider-tf-ec2-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 2
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "haider-tf-ecs-cluster-capacity-providers" {
  cluster_name = var.cluster_name

  capacity_providers = [aws_ecs_capacity_provider.haider-tf-ec2-capacity-provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.haider-tf-ec2-capacity-provider.name
  }
}

resource "aws_ecs_task_definition" "haider-tf-td-nginx-custom" {
  family                   = var.task_definition_family
  execution_role_arn       = var.task_execution_role_arn
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${var.container_image}"
      essential = true
      cpu       = 512
      memory    = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "haider-tf-efs-volume"
          containerPath = "/mnt/efs"
          readOnly      = false
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

  volume {
    name = "haider-tf-efs-volume"
    efs_volume_configuration {
      file_system_id = var.efs_volume_id
      root_directory = "/"
    }
  }
}

resource "aws_ecs_service" "haider-tf-ecs-service" {
  name            = var.service_name
  launch_type     = "EC2"
  desired_count   = var.tasks_count
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.haider-tf-td-nginx-custom.arn

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
  }

  load_balancer {
    container_name   = var.container_name
    container_port   = 80
    target_group_arn = var.target_group_arn
  }

  depends_on = [
    aws_ecs_capacity_provider.haider-tf-ec2-capacity-provider,
    aws_ecs_cluster_capacity_providers.haider-tf-ecs-cluster-capacity-providers,
    aws_ecs_task_definition.haider-tf-td-nginx-custom
  ]
}