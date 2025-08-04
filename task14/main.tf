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

  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}

module "sg" {
  source = "./sg"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "iam" {
  source = "./iam"

  ec2_container_registry_power_user_policy_arn = var.ec2_container_registry_power_user_policy_arn
  ecs_full_access_policy_arn                   = var.ecs_full_access_policy_arn
  cloudwatch_logs_full_access_policy_arn       = var.cloudwatch_logs_full_access_policy_arn
  task_execution_role_name                     = var.task_execution_role_name
  task_execution_role_policy_arn               = var.task_execution_role_policy_arn
}

module "ec2" {
  source = "./ec2"

  instance_type     = var.instance_type
  master_key_name   = var.master_key_name
  slave_key_name    = var.slave_key_name
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.sg.security_group_id

  depends_on = [module.sg]
}

module "ecr" {
  source = "./ecr"

  profile = var.profile
  region  = var.region
}

# module "ecs" {
#   source = "./ecs"
# 
#   cluster_name            = var.cluster_name
#   task_definition_family  = var.task_definition_family
#   task_execution_role_arn = module.iam.execution_role_arn
#   container_name          = var.container_name
#   container_image         = module.ecr.image_uri
#   service_name            = var.service_name
#   tasks_count             = var.tasks_count
#   security_group_id       = module.sg.security_group_id
#   subnet_ids              = [module.vpc.subnet_id]
# 
#   depends_on = [module.iam, module.sg, module.ecr]
# }