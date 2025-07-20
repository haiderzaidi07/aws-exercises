resource "aws_ecs_cluster" "haider-tf-ecs-cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "haider-tf-td-nginx-custom" {
  family                   = var.task_definition_family
  execution_role_arn       = var.task_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "${var.container_name}"
      image     = "${var.container_image}"
      essential = true
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
          awslogs-group         = "/ecs/${var.cluster_name}"
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
  name             = var.cluster_name
  launch_type      = "FARGATE"
  platform_version = "LATEST"
  desired_count    = var.tasks_count
  cluster          = aws_ecs_cluster.haider-tf-ecs-cluster.id
  task_definition  = aws_ecs_task_definition.haider-tf-td-nginx-custom.arn

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_cluster.haider-tf-ecs-cluster, aws_ecs_task_definition.haider-tf-td-nginx-custom]

  load_balancer {
    container_name   = var.container_name
    container_port   = 80
    target_group_arn = var.target_group_arn
  }
}