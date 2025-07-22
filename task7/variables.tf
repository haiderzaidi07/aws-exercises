variable "region" {
  type = string
}

variable "profile" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "instance_tenancy" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "az_1" {
  type = string
}

variable "az_2" {
  type = string
}

variable "task_execution_role_name" {
  type = string
}

variable "task_execution_policy_arn" {
  type = string
}

variable "cloud_watch_logs_full_access_policy_arn" {
  type = string
}

variable "ecs_instance_role_name" {
  type = string
}

variable "ec2_container_service_for_ec2_policy_arn" {
  type        = string
  description = "ARN of the policy for ECS instances to interact with EC2"
}

variable "instance_lt_name" {
  type = string
}

variable "image_ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "task_definition_family" {
  type = string
}

variable "container_name" {
  type = string
}

variable "service_name" {
  type = string
}

variable "tasks_count" {
  type = string
}