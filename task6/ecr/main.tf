resource "aws_ecr_repository" "haider-tf-ecr" {
  name                 = "haider-tf-ecr"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_caller_identity" "current" {}

resource "null_resource" "push_custom_docker_nginx_image" {

  provisioner "local-exec" {
    command = <<EOF
        aws ecr get-login-password --region ${var.region} --profile ${var.profile} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-2.amazonaws.com
        docker build -t ${var.container_name} ../
        docker tag ${var.container_name}:latest ${aws_ecr_repository.haider-tf-ecr.repository_url}:latest
        docker push ${aws_ecr_repository.haider-tf-ecr.repository_url}:latest
    EOF
  }

  triggers = {
    "run_at" = timestamp()
  }

  depends_on = [aws_ecr_repository.haider-tf-ecr]
}