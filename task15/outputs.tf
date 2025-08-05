output "jenkins_agent_public_ip" {
  value = module.ec2.jenkins_agent_public_ip
}

output "nodejs_ec2_public_ip" {
  value = module.ec2.nodejs_ec2_public_ip
}