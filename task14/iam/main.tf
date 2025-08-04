# Jenkins IAM User
resource "aws_iam_user" "haider-tf-jenkins-user" {
  name          = "haider-tf-jenkins-user"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "ec2_container_registry_power_user_policy_attachment" {
  user       = aws_iam_user.haider-tf-jenkins-user.name
  policy_arn = var.ec2_container_registry_power_user_policy_arn
}

resource "aws_iam_user_policy_attachment" "ecs_full_access_policy_attachment" {
  user       = aws_iam_user.haider-tf-jenkins-user.name
  policy_arn = var.ecs_full_access_policy_arn
}

resource "aws_iam_user_policy_attachment" "cloudwatch_logs_full_access_policy_attachment" {
  user       = aws_iam_user.haider-tf-jenkins-user.name
  policy_arn = var.cloudwatch_logs_full_access_policy_arn
}

# Jenkins IAM User Access Keys
resource "aws_iam_access_key" "haider-tf-jenkins-user-access-key" {
  user = aws_iam_user.haider-tf-jenkins-user.name
}

# ECS Task Execution Role
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
  policy_arn = var.task_execution_role_policy_arn
}