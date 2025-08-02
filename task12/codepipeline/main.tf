resource "aws_codepipeline" "haider-tf-pipeline" {
  name     = "haider-tf-pipeline"
  role_arn = var.service_role

  artifact_store {
    location = aws_s3_bucket.haider-tf-codepipeline-bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codeconnections:us-east-2:${var.codeconnection_id}"
        FullRepositoryId = "haiderzaidi07/aws-exercises"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  #stage {
  #  name = "Deploy"
  #
  #  action {
  #    name             = "Deploy"
  #    category         = "Deploy"
  #    owner            = "AWS"
  #    provider         = "ECS"
  #    input_artifacts  = ["build_output"]
  #    version          = "1"
  #
  #    configuration = {
  #      ClusterName = "haider-tf-ecs-ec2-cluster"
  #      ServiceName = "haider-tf-ecs-ec2-service"
  #    }
  #  }
  #}

  depends_on = [aws_s3_bucket.haider-tf-codepipeline-bucket]
}

# resource "aws_codestarconnections_connection" "example" {
#   name          = "example-connection"
#   provider_type = "GitHub"
# }

resource "aws_s3_bucket" "haider-tf-codepipeline-bucket" {
  bucket = "haider-tf-codepipeline-bucket"

  lifecycle {
    prevent_destroy = false
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.haider-tf-codepipeline-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.haider-tf-codepipeline-bucket]
}