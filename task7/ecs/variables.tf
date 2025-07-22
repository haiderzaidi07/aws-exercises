variable "cluster_name" {
  type = string
}

variable "asg_arn" {
  type        = string
  description = "ARN of the Auto Scaling Group for ECS instances"
}

variable "task_definition_family" {
  type = string
}

variable "task_execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role"
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type        = string
  description = "Docker image to be used in the ECS task"
}

variable "efs_volume_id" {
  type        = string
  description = "ID of the EFS volume to be used by the ECS task"
}

variable "service_name" {
  type = string
}

variable "tasks_count" {
  type = number
}

variable "cluster_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ECS service"
}

variable "security_group_id" {
  type        = string
  description = "ID of the security group for the ECS service"
}

variable "target_group_arn" {
  type = string
}