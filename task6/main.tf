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

  vpc_cidr              = var.vpc_cidr
  instance_tenancy      = var.instance_tenancy
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  az_1                  = var.az_1
  az_2                  = var.az_2
}

module "sg" {
  source = "./sg"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "efs" {
  source = "./efs"

  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.sg.efs_sg_id

  depends_on = [module.vpc]
}

module "iam" {
  source = "./iam"

  task_execution_role_name                = var.task_execution_role_name
  task_execution_policy_arn               = var.task_execution_policy_arn
  cloud_watch_logs_full_access_policy_arn = var.cloud_watch_logs_full_access_policy_arn
}

module "ecr" {
  source = "./ecr"

  profile        = var.profile
  region         = var.region
  container_name = var.container_name
}

module "alb" {
  source = "./alb"

  security_group_id = module.sg.alb_sg_id
  subnet_ids        = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
}

module "ecs" {
  source = "./ecs"

  cluster_name            = var.cluster_name
  task_definition_family  = var.task_definition_family
  task_execution_role_arn = module.iam.execution_role_arn
  container_name          = var.container_name
  container_image         = module.ecr.image_uri
  efs_volume_id           = module.efs.efs_id
  service_name            = var.service_name
  tasks_count             = var.tasks_count
  security_group_id       = module.sg.ecs_sg_id
  subnet_ids              = module.vpc.public_subnet_ids
  target_group_arn        = module.alb.target_group_arn

  depends_on = [module.sg, module.efs, module.ecr, module.alb]
}