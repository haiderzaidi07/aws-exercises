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

variable "security_group_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "ecs_instance_profile_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}