resource "aws_launch_template" "haider-tf-lt" {
  name_prefix   = var.instance_lt_name
  image_id      = var.image_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/../ecs.sh")

  # If not using a public IP address, uncomment the following line and delete the network_interfaces block
  # vpc_security_group_ids = [ var.security_group_id ]

  iam_instance_profile {
    arn = var.ecs_instance_profile_arn
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }
}

resource "aws_ecs_cluster" "haider-tf-ecs-cluster" {
  name = var.cluster_name
}

resource "aws_autoscaling_group" "haider-tf-asg" {
  name                = "haider-tf-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 0
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.haider-tf-lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.haider-tf-lt, aws_ecs_cluster.haider-tf-ecs-cluster]
}