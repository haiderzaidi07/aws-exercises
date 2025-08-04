variable "region" {
  description = "AWS region"
  type        = string
}

variable "profile" {
  description = "AWS CLI profile name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone of the subnet"
  type        = string
}

variable "ec2_container_registry_power_user_policy_arn" {
  type = string
}

variable "ecs_full_access_policy_arn" {
  type = string
}

variable "cloudwatch_logs_full_access_policy_arn" {
  type = string
}

variable "task_execution_role_name" {
  type        = string
  description = "The name of the ECS task execution role"
}

variable "task_execution_role_policy_arn" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "master_key_name" {
  type = string
}

variable "slave_key_name" {
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