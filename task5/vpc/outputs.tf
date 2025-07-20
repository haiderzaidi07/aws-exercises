output "vpc_id" {
  value       = aws_vpc.haider-tf-vpc.id
  description = "Value of the VPC ID"
}

output "subnet_ids" {
  value       = [aws_subnet.haider-tf-subnet-1.id, aws_subnet.haider-tf-subnet-2.id]
  description = "List of subnet IDs in the VPC"
}