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
}

module "s3" {
  source = "./s3"
}

module "beanstalk" {
  source = "./beanstalk"

  bucket_id             = module.s3.bucket_id
  object_key            = module.s3.object_key
  instance_profile_name = module.iam.ec2_instance_profile_name
  service_role_name     = module.iam.beanstalk_service_role_name

  depends_on = [module.iam, module.s3]
}