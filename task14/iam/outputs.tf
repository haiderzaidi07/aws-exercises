output "access_key_id" {
  value = aws_iam_access_key.haider-tf-jenkins-user-access-key.id
}

# output "access_key_secret" {
#   value = aws_iam_access_key.haider-tf-jenkins-user-access-key.secret
# }

output "execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN of the ECS task execution role"
}