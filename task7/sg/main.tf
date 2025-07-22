resource "aws_security_group" "haider-tf-sg-ecs" {
  name   = "haider-tf-sg-ecs"
  vpc_id = var.vpc_id

  tags = {
    Name = "haider-tf-sg-ecs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http-ecs" {
  security_group_id = aws_security_group.haider-tf-sg-ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_egress_rule" "all-ecs" {
  security_group_id = aws_security_group.haider-tf-sg-ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_security_group" "haider-tf-sg-efs" {
  name   = "haider-tf-sg-efs"
  vpc_id = var.vpc_id

  tags = {
    Name = "haider-tf-sg-efs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nfs" {
  security_group_id = aws_security_group.haider-tf-sg-efs.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 2049
  to_port           = 2049
  ip_protocol       = "tcp"
  description       = "Allow NFS"
}

resource "aws_vpc_security_group_egress_rule" "all-efs" {
  security_group_id = aws_security_group.haider-tf-sg-efs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

resource "aws_security_group" "haider-tf-sg-alb" {
  name   = "haider-tf-sg-alb"
  vpc_id = var.vpc_id

  tags = {
    Name = "haider-tf-sg-alb"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http-alb" {
  security_group_id = aws_security_group.haider-tf-sg-alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow HTTP"
}

resource "aws_vpc_security_group_egress_rule" "all-alb" {
  security_group_id = aws_security_group.haider-tf-sg-alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}