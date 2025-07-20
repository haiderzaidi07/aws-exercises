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
  subnet_1_az      = var.subnet_1_az
  subnet_2_cidr    = var.subnet_2_cidr
  subnet_2_az      = var.subnet_2_az
}

module "sg" {
  source = "./sg"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "iam" {
  source = "./iam"

  task_execution_role_name       = var.task_execution_role_name
  task_execution_role_policy_arn = var.task_execution_role_policy_arn
}

module "ecr" {
  source = "./ecr"

  profile = var.profile
  region  = var.region
}

module "ecs" {
  source = "./ecs"

  cluster_name            = var.cluster_name
  task_definition_family  = var.task_definition_family
  task_execution_role_arn = module.iam.execution_role_arn
  container_name          = var.container_name
  container_image         = module.ecr.image_uri
  service_name            = var.service_name
  tasks_count             = var.tasks_count
  security_group_id       = module.sg.sg_id
  subnet_ids              = module.vpc.subnet_ids

  depends_on = [module.iam, module.sg, module.ecr]
}