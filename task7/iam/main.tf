resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.task_execution_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.task_execution_policy_arn
}

resource "aws_iam_role_policy_attachment" "cloud_watch_logs_full_access_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = var.cloud_watch_logs_full_access_policy_arn
}

resource "aws_iam_role" "ecs_instance_role" {
  name = var.ecs_instance_role_name

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_container_service_for_ec2_policy_attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = var.ec2_container_service_for_ec2_policy_arn
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = var.ecs_instance_role_name
  role = aws_iam_role.ecs_instance_role.name
}