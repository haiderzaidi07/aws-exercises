output "master_public_ip" {
  value = aws_instance.haider-tf-jenkins-master.public_ip
}

output "slave_public_ip" {
  value = aws_instance.haider-tf-jenkins-slave.public_ip
}