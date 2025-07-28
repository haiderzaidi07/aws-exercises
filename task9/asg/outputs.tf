output "asg_arn" {
  value = aws_autoscaling_group.haider-tf-asg.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.haider-tf-ecs-cluster.id
}