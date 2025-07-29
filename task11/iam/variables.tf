variable "service_role_name" {
  type = string
}

variable "elastic_beanstalk_enhanced_health_policy_arn" {
  type = string
}

variable "elastic_beanstalk_managed_updates_customer_role_policy_arn" {
  type = string
}

variable "ec2_role_name" {
  type = string
}

variable "ssm_managed_ec2_instance_default_policy_arn" {
  type = string
}

variable "elastic_beanstalk_multicontainer_docker_policy_arn" {
  type = string
}

variable "elastic_beanstalk_web_tier_policy_arn" {
  type = string
}

variable "elastic_beanstalk_worker_tier_policy_arn" {
  type = string
}

variable "ec2_instance_profile_name" {
  type = string
}