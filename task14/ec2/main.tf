data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "haider-tf-jenkins-master" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.master_key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  user_data                   = file("${path.root}/master_node.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "haider-tf-jenkins-master"
  }
}

resource "aws_instance" "haider-tf-jenkins-slave" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.slave_key_name
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  user_data                   = file("${path.root}/slave_node.sh")

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "haider-tf-jenkins-slave"
  }
}