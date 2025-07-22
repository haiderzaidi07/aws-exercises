resource "aws_lb" "haider-tf-alb" {
  name               = "haider-tf-alb"
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.haider-tf-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.haider-tf-tg.arn
  }

  depends_on = [aws_lb.haider-tf-alb, aws_lb_target_group.haider-tf-tg]
}

resource "aws_lb_target_group" "haider-tf-tg" {
  name        = "haider-tf-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}