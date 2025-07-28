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

variable "ec2_container_registry_power_user_policy_arn" {
  type = string
}

variable "codebuild_log_group_arn" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "codebuild_report_group_arn" {
  type = string
}

variable "codeconnection_id" {
  type = string
}

variable "ecs_full_access_policy_arn" {
  type = string
}

variable "codebuild_project_arn" {
  type = string
}