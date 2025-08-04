terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "s3" {
  source = "./s3"

  bucket_name = var.bucket_name
}

module "iam" {
  source = "./iam"

  service_role_name                                          = var.service_role_name
  elastic_beanstalk_enhanced_health_policy_arn               = var.elastic_beanstalk_enhanced_health_policy_arn
  elastic_beanstalk_managed_updates_customer_role_policy_arn = var.elastic_beanstalk_managed_updates_customer_role_policy_arn
  ec2_role_name                                              = var.ec2_role_name
  ssm_managed_ec2_instance_default_policy_arn                = var.ssm_managed_ec2_instance_default_policy_arn
  elastic_beanstalk_multicontainer_docker_policy_arn         = var.elastic_beanstalk_multicontainer_docker_policy_arn
  elastic_beanstalk_web_tier_policy_arn                      = var.elastic_beanstalk_web_tier_policy_arn
  elastic_beanstalk_worker_tier_policy_arn                   = var.elastic_beanstalk_worker_tier_policy_arn
  ec2_instance_profile_name                                  = var.ec2_instance_profile_name
  codebuild_log_group_arn                                    = var.codebuild_log_group_arn
  s3_bucket_arn                                              = module.s3.bucket_arn
  codebuild_report_group_arn                                 = var.codebuild_report_group_arn
  codeconnection_id                                          = var.codeconnection_id
  elastic_beanstalk_administrator_access_policy_arn          = var.elastic_beanstalk_administrator_access_policy_arn
  codebuild_project_arn                                      = var.codebuild_project_arn

  depends_on = [module.s3]
}

module "beanstalk" {
  source = "./beanstalk"

  bucket_id             = module.s3.bucket_id
  object_key            = module.s3.object_key
  instance_profile_name = module.iam.ec2_instance_profile_name
  service_role_name     = module.iam.beanstalk_service_role_name

  depends_on = [module.iam, module.s3]
}

module "codebuild" {
  source = "./codebuild"

  service_role = module.iam.codebuild_service_role_arn

  depends_on = [module.iam]
}

module "codepipeline" {
  source = "./codepipeline"

  service_role            = module.iam.codepipeline_service_role_arn
  artifact_store_location = module.s3.bucket_location
  codeconnection_id       = var.codeconnection_id
  codebuild_project_name  = module.codebuild.codebuild_project_name
  application_name        = module.beanstalk.application_name
  environment_name        = module.beanstalk.environment_name

  depends_on = [module.s3, module.beanstalk, module.codebuild]
}