output "ecs_sg_id" {
  value = aws_security_group.haider-tf-sg-ecs.id
}

output "alb_sg_id" {
  value = aws_security_group.haider-tf-sg-alb.id
}