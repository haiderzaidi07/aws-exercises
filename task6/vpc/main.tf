resource "aws_vpc" "haider-tf-vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = true

  tags = {
    Name = "haider-tf-vpc"
  }
}

resource "aws_subnet" "haider-tf-public-subnet-1" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "haider-tf-public-subnet-1"
  }
}

resource "aws_subnet" "haider-tf-public-subnet-2" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = var.az_2

  tags = {
    Name = "haider-tf-public-subnet-2"
  }
}

resource "aws_subnet" "haider-tf-private-subnet-1" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = var.az_1

  tags = {
    Name = "haider-tf-private-subnet-1"
  }
}

resource "aws_subnet" "haider-tf-private-subnet-2" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.az_2

  tags = {
    Name = "haider-tf-private-subnet-2"
  }
}

resource "aws_internet_gateway" "haider-tf-igw" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  tags = {
    Name = "haider-tf-igw"
  }
}

resource "aws_route_table" "haider-tf-public-rt" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haider-tf-igw.id
  }

  tags = {
    Name = "haider-tf-public-rt"
  }
}

resource "aws_route_table" "haider-tf-private-rt" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  tags = {
    Name = "haider-tf-private-rt"
  }
}

resource "aws_route_table_association" "haider-tf-public-rt-assoc-1" {
  subnet_id      = aws_subnet.haider-tf-public-subnet-1.id
  route_table_id = aws_route_table.haider-tf-public-rt.id

  depends_on = [aws_internet_gateway.haider-tf-igw]
}

resource "aws_route_table_association" "haider-tf-public-rt-assoc-2" {
  subnet_id      = aws_subnet.haider-tf-public-subnet-2.id
  route_table_id = aws_route_table.haider-tf-public-rt.id

  depends_on = [aws_internet_gateway.haider-tf-igw]
}

resource "aws_route_table_association" "haider-tf-private-rt-assoc-1" {
  subnet_id      = aws_subnet.haider-tf-private-subnet-1.id
  route_table_id = aws_route_table.haider-tf-private-rt.id
}

resource "aws_route_table_association" "haider-tf-private-rt-assoc-2" {
  subnet_id      = aws_subnet.haider-tf-private-subnet-2.id
  route_table_id = aws_route_table.haider-tf-private-rt.id
}