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

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}