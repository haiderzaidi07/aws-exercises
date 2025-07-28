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