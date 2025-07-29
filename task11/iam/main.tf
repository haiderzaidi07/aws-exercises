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