output "beanstalk_service_role_name" {
  value = aws_iam_role.elastic_beanstalk_service_role.name
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "codebuild_service_role_arn" {
  value       = aws_iam_role.codebuild_haider_tf_build_beanstalk_service_role.arn
  description = "ARN of the CodeBuild service role"
}

output "codepipeline_service_role_arn" {
  value       = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.arn
  description = "ARN of the CodePipeline service role"
}