output "codebuild_project_name" {
  value       = aws_codebuild_project.haider-tf-build-beanstalk.name
  description = "Name of the CodeBuild project"
}