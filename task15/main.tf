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

module "ec2" {
  source = "./ec2"

  instance_type     = var.instance_type
  jenkins_agent_key = var.jenkins_agent_key
  nodejs_ec2_key    = var.nodejs_ec2_key
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.sg.security_group_id

  depends_on = [module.sg]
}