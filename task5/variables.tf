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

variable "subnet_1_cidr" {
  type = string
}

variable "subnet_1_az" {
  type = string
}

variable "subnet_2_cidr" {
  type = string
}

variable "subnet_2_az" {
  type = string
}

variable "task_execution_role_name" {
  type = string
}

variable "task_execution_role_policy_arn" {
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