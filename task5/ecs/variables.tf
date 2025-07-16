variable "cluster_name" {
  type = string
}

variable "task_definition_family" {
  type = string
}

variable "task_execution_role_arn" {
  type = string
    description = "ARN of the ECS task execution role"
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
  description = "Docker image to be used in the ECS task"
}

variable "service_name" {
  type = string
}

variable "tasks_count" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
  description = "List of subnet IDs for the ECS service"
}

variable "security_group_id" {
  type = string
  description = "ID of the security group for the ECS service"
}