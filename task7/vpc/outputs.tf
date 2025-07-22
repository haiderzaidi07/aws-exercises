output "vpc_id" {
  value       = aws_vpc.haider-tf-vpc.id
  description = "Value of the VPC ID"
}

output "public_subnet_ids" {
  value       = [aws_subnet.haider-tf-public-subnet-1.id, aws_subnet.haider-tf-public-subnet-2.id]
  description = "List of public subnet IDs in the VPC"
}

output "private_subnet_ids" {
  value       = [aws_subnet.haider-tf-private-subnet-1.id, aws_subnet.haider-tf-private-subnet-2.id]
  description = "List of private subnet IDs in the VPC"
}