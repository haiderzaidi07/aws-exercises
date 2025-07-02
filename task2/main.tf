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
  region  = var.aws_region
  profile = var.aws_profile
}

# --- Networking ---
resource "aws_vpc" "haider-tf-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "haider-tf-vpc"
  }
}

resource "aws_subnet" "haider-tf-subnet" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "haider-tf-subnet"
  }
}

resource "aws_internet_gateway" "haider-tf-igw" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  tags = {
    Name = "haider-tf-igw"
  }
}

resource "aws_route_table" "haider-tf-rt" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haider-tf-igw.id
  }

  tags = {
    Name = "haider-tf-rt"
  }
}

resource "aws_route_table_association" "haider-tf-rt-assoc" {
  subnet_id      = aws_subnet.haider-tf-subnet.id
  route_table_id = aws_route_table.haider-tf-rt.id

  depends_on = [aws_internet_gateway.haider-tf-igw]
}

# --- Security Group ---
resource "aws_security_group" "haider-tf-sg" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  tags = {
    Name = "haider-tf-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  description       = "Allow MySQL"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# --- AMI Lookup ---
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

# --- EC2 Instance ---
resource "aws_instance" "haider-tf-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.haider-tf-subnet.id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.haider-tf-sg.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")

  tags = {
    Name = "haider-tf-ec2"
  }

  depends_on = [aws_route_table_association.haider-tf-rt-assoc]
}