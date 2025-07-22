output "image_uri" {
  value       = aws_ecr_repository.haider-tf-ecr.repository_url
  description = "URI of the ECR repository for the Docker image"
}