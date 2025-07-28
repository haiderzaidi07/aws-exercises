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

module "vpc" {
  source = "./vpc"

  vpc_cidr         = var.vpc_cidr
  instance_tenancy = var.instance_tenancy
  subnet_1_cidr    = var.subnet_1_cidr
  subnet_2_cidr    = var.subnet_2_cidr
  az_1             = var.az_1
  az_2             = var.az_2
}

module "sg" {
  source = "./sg"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "iam" {
  source = "./iam"

  task_execution_role_name                     = var.task_execution_role_name
  task_execution_policy_arn                    = var.task_execution_policy_arn
  cloud_watch_logs_full_access_policy_arn      = var.cloud_watch_logs_full_access_policy_arn
  ecs_instance_role_name                       = var.ecs_instance_role_name
  ec2_container_service_for_ec2_policy_arn     = var.ec2_container_service_for_ec2_policy_arn
  ec2_container_registry_power_user_policy_arn = var.ec2_container_registry_power_user_policy_arn
  codebuild_log_group_arn                      = var.codebuild_log_group_arn
  s3_bucket_arn                                = var.s3_bucket_arn
  codebuild_report_group_arn                   = var.codebuild_report_group_arn
  codeconnection_id                            = var.codeconnection_id
  ecs_full_access_policy_arn                   = var.ecs_full_access_policy_arn
  codebuild_project_arn                        = var.codebuild_project_arn
}

# module "ecr" {
#   source = "./ecr"
# 
#   profile        = var.profile
#   region         = var.region
#   container_name = var.container_name
# }

# module "alb" {
#   source = "./alb"
# 
#   security_group_id = module.sg.alb_sg_id
#   subnet_ids        = module.vpc.subnet_ids
#   vpc_id            = module.vpc.vpc_id
# 
#   depends_on = [module.vpc]
# }
# 
# module "asg" {
#   source = "./asg"
# 
#   instance_lt_name         = var.instance_lt_name
#   image_ami_id             = var.image_ami_id
#   instance_type            = var.instance_type
#   key_name                 = var.key_name
#   security_group_id        = module.sg.ecs_sg_id
#   cluster_name             = var.cluster_name
#   subnet_ids               = module.vpc.subnet_ids
#   ecs_instance_profile_arn = module.iam.ecs_instance_profile_arn
# 
#   depends_on = [module.sg]
# }
# 
# module "ecs" {
#   source = "./ecs"
# 
#   cluster_name            = var.cluster_name
#   asg_arn                 = module.asg.asg_arn
#   task_definition_family  = var.task_definition_family
#   task_execution_role_arn = module.iam.execution_role_arn
#   container_name          = var.container_name
#   container_image         = "504649076991.dkr.ecr.us-east-2.amazonaws.com/haider-nginx:d1cdfc8" # module.ecr.image_uri
#   service_name            = var.service_name
#   tasks_count             = var.tasks_count
#   cluster_id              = module.asg.cluster_id
#   security_group_id       = module.sg.ecs_sg_id
#   subnet_ids              = module.vpc.subnet_ids
#   target_group_arn        = module.alb.target_group_arn
# 
#   depends_on = [module.iam, module.sg, module.asg, module.alb] # module.ecr]
# }

module "codebuild" {
  source = "./codebuild"

  service_role = module.iam.codebuild_service_role_arn

  depends_on = [module.iam]
}

module "codepipeline" {
  source = "./codepipeline"

  service_role      = module.iam.codepipeline_service_role_arn
  codeconnection_id = var.codeconnection_id

  depends_on = [module.iam, module.codebuild]
}