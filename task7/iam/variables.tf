variable "task_execution_role_name" {
  type        = string
  description = "The name of the ECS task execution role"
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