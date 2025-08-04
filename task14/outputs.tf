output "master_public_ip" {
  value = module.ec2.master_public_ip
}

output "slave_public_ip" {
  value = module.ec2.slave_public_ip
}

output "access_key_id" {
  value = module.iam.access_key_id
}

# output "access_key_secret" {
#   value = module.iam.access_key_secret
#   sensitive = true
# }