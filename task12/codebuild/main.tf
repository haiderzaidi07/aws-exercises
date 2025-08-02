resource "aws_codebuild_project" "haider-tf-build-beanstalk" {
  name         = "haider-tf-build-beanstalk"
  service_role = var.service_role

  source {
    type            = "GITHUB"
    location        = "https://github.com/haiderzaidi07/aws-exercises.git"
    git_clone_depth = 1
    buildspec       = "task12/buildspec.yml"

    # auth {
    #     type     = "CODECONNECTIONS"
    #     resource = "arn:aws:codestar-connections:us-east-1:123456789012:connection/guid-string"
    # }
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "haider-tf-build-beanstalk"
    }
  }

  # vpc_config {
  #   vpc_id = aws_vpc.example.id
  # 
  #   subnets = [
  #     aws_subnet.example1.id,
  #     aws_subnet.example2.id,
  #   ]
  #
  #   security_group_ids = [
  #     aws_security_group.example1.id,
  #     aws_security_group.example2.id,
  #   ]
  # }
}