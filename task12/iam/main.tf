# Elastic Beanstalk Service Role
resource "aws_iam_role" "elastic_beanstalk_service_role" {
  name = var.service_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_enhanced_health_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = var.elastic_beanstalk_enhanced_health_policy_arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_managed_updates_customer_role_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = var.elastic_beanstalk_managed_updates_customer_role_policy_arn
}

# Elastic Beanstalk EC2 Role
resource "aws_iam_role" "elastic_beanstalk_ec2_role" {
  name = var.ec2_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_ec2_instance_default_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = var.ssm_managed_ec2_instance_default_policy_arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_multicontainer_docker_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = var.elastic_beanstalk_multicontainer_docker_policy_arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_web_tier_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = var.elastic_beanstalk_web_tier_policy_arn
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_worker_tier_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_ec2_role.name
  policy_arn = var.elastic_beanstalk_worker_tier_policy_arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.ec2_instance_profile_name
  role = aws_iam_role.elastic_beanstalk_ec2_role.name
}

# CodeBuild Service Role
resource "aws_iam_role" "codebuild_haider_tf_build_beanstalk_service_role" {
  name = "codebuild-haider-tf-build-beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "CodeBuildBasePolicy-haider-tf-build-beanstalk-us-east-2" {
  name = "CodeBuildBasePolicy-haider-tf-build-beanstalk-us-east-2"
  role = aws_iam_role.codebuild_haider_tf_build_beanstalk_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "${var.codebuild_log_group_arn}",
          "${var.codebuild_log_group_arn}:*"
        ]
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Effect = "Allow"
        Resource = [
          "${var.s3_bucket_arn}/*"
        ]
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        Effect = "Allow",
        Resource = [
          "${var.codebuild_report_group_arn}-*"
        ]
        Action = [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "CodeBuildCodeConnectionsSourceCredentialsPolicy-haider-tf-build-beanstalk-us-east-2" {
  name = "CodeBuildCodeConnectionsSourceCredentialsPolicy-haider-tf-build-beanstalk-us-east-2"
  role = aws_iam_role.codebuild_haider_tf_build_beanstalk_service_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codestar-connections:GetConnectionToken",
          "codestar-connections:GetConnection",
          "codeconnections:GetConnectionToken",
          "codeconnections:GetConnection",
          "codeconnections:UseConnection"
        ]
        Resource = [
          "arn:aws:codestar-connections:us-east-2:${var.codeconnection_id}",
          "arn:aws:codeconnections:us-east-2:${var.codeconnection_id}"
        ]
      }
    ]
  })
}

# CodePipeline Service Role
resource "aws_iam_role" "codepipeline-haider-tf-pipeline-service-role" {
  name = "AWSCodePipelineServiceRole-us-east-2-haider-tf-pipeline"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "CodePipelineTrustPolicy"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "504649076991"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_administrator_access_policy_attachment" {
  role       = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.name
  policy_arn = var.elastic_beanstalk_administrator_access_policy_arn
}

resource "aws_iam_role_policy" "CodePipeline-S3-us-east-2-haider-tf-pipeline" {
  name = "CodePipeline-S3-us-east-2-haider-tf-pipeline"
  role = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowS3BucketAccess",
        Effect = "Allow",
        Action = [
          "s3:GetBucketVersioning",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "${var.s3_bucket_arn}"
        ],
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = "504649076991"
          }
        }
      },
      {
        Sid    = "AllowS3ObjectAccess",
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectVersion"
        ],
        Resource = [
          "${var.s3_bucket_arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = "504649076991"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "CodePipeline-CodeBuild-us-east-2-haider-tf-pipeline" {
  name = "CodePipeline-CodeBuild-us-east-2-haider-tf-pipeline"
  role = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ]
        Resource = [
          "${var.codebuild_project_arn}",
        ]
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "CodePipeline-CodeConnections-us-east-2-haider-tf-pipeline" {
  name = "CodePipeline-CodeConnections-us-east-2-haider-tf-pipeline"
  role = aws_iam_role.codepipeline-haider-tf-pipeline-service-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = [
          "arn:aws:codestar-connections:*:${var.codeconnection_id}",
          "arn:aws:codeconnections:*:${var.codeconnection_id}"
        ]
      }
    ]
  })
}
