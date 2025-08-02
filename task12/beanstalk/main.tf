resource "aws_elastic_beanstalk_application" "haider-tf-nodejs-app" {
  name        = "haider-tf-nodejs-app"
  description = "This is a Node.js application deployed using Terraform"
}

resource "aws_elastic_beanstalk_application_version" "haider-tf-nodejs-app-version" {
  name        = "v1"
  application = aws_elastic_beanstalk_application.haider-tf-nodejs-app.name
  bucket      = var.bucket_id
  key         = var.object_key
}

resource "aws_elastic_beanstalk_environment" "haider-tf-nodejs-app-env" {
  name                = "haider-tf-nodejs-app-env"
  application         = aws_elastic_beanstalk_application.haider-tf-nodejs-app.name
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2023 v6.6.1 running Node.js 22"
  version_label       = aws_elastic_beanstalk_application_version.haider-tf-nodejs-app-version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_name
  }
}
