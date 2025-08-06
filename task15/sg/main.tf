resource "aws_security_group" "haider-tf-sg" {
  vpc_id = var.vpc_id

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

resource "aws_vpc_security_group_ingress_rule" "jenkins-port" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  description       = "Allow Jenkins"
}

resource "aws_vpc_security_group_ingress_rule" "nodejs-port" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  description       = "Allow Node.js"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.haider-tf-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}