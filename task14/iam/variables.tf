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