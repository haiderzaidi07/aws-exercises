terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
  profile = "haider.zaidi"
}

# --- Security Group ---
resource "aws_security_group" "haider-sg" {
  tags = {
    Name = "haider-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.haider-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.haider-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.haider-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow HTTPS"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.haider-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

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

# --- EC2 Instances ---
resource "aws_instance" "haider-backend-1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = "haider-ce-key"
  vpc_security_group_ids      = [aws_security_group.haider-sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash

    sudo apt update -y
    sudo apt upgrade -y

    # Nginx Installation
    sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx
    sudo apt update -y
    sudo apt install nginx -y

    # Starting Nginx
    sudo systemctl start nginx

    # Modifying the default Nginx page
    cd /usr/share/nginx/html
    sudo sed -i 's/<title>Welcome to nginx!<\/title>/<title>AWS Task 4<\/title>/' index.html
    sudo sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Backend Server 1<\/h1>/' index.html
  EOF

  tags = {
    Name = "haider-backend-1"
  }
}

resource "aws_instance" "haider-backend-2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = "haider-ce-key"
  vpc_security_group_ids      = [aws_security_group.haider-sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash

    sudo apt update -y
    sudo apt upgrade -y

    sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx
    sudo apt update -y
    sudo apt install nginx -y

    sudo systemctl start nginx

    cd /usr/share/nginx/html
    sudo sed -i 's/<title>Welcome to nginx!<\/title>/<title>AWS Task 4<\/title>/' index.html
    sudo sed -i 's/<h1>Welcome to nginx!<\/h1>/<h1>Backend Server 2<\/h1>/' index.html
  EOF

  tags = {
    Name = "haider-backend-2"
  }
}

resource "aws_instance" "haider-nginx-lb" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = "haider-ce-key"
  vpc_security_group_ids      = [aws_security_group.haider-sg.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash

    sudo apt update -y
    sudo apt upgrade -y

    sudo apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring -y
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
        | sudo tee /etc/apt/preferences.d/99nginx
    sudo apt update -y
    sudo apt install nginx -y
  EOF

  tags = {
    Name = "haider-nginx-lb"
  }
}