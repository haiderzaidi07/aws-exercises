output "execution_role_arn" {
  value       = aws_iam_role.ecs_task_execution_role.arn
  description = "ARN of the ECS task execution role"
}

output "ecs_instance_profile_arn" {
  value       = aws_iam_instance_profile.ecs_instance_profile.arn
  description = "ARN of the ECS instance profile"
}

output "codebuild_service_role_arn" {
  value       = aws_iam_role.codebuild_haider_tf_build_ecs_service_role.arn
  description = "ARN of the CodeBuild service role"
}

output "codepipeline_service_role_arn" {
  value       = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.arn
  description = "ARN of the CodePipeline service role"
}