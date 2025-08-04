output "application_name" {
  value = aws_elastic_beanstalk_application.haider-tf-nodejs-app.name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.haider-tf-nodejs-app-env.name
}