output "target_group_arn" {
  value = aws_lb_target_group.haider-tf-tg.arn
}

output "alb_dns_name" {
  value = aws_lb.haider-tf-alb.dns_name
}