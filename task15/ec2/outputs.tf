output "jenkins_agent_public_ip" {
  value = aws_instance.haider-tf-jenkins-agent.public_ip
}

output "nodejs_ec2_public_ip" {
  value = aws_instance.haider-tf-nodejs-ec2.public_ip
}