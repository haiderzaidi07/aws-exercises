output "execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN of the ECS task execution role"
}

output "ecs_instance_profile_arn" {
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
  description = "ARN of the ECS instance profile"
}