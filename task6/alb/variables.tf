variable "security_group_id" {
  type        = string
  description = "ID of the security group for the ALB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ALB"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the ALB will be created"
}