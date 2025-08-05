resource "aws_vpc" "haider-tf-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "haider-tf-vpc"
  }
}

resource "aws_subnet" "haider-tf-subnet" {
  vpc_id            = aws_vpc.haider-tf-vpc.id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "haider-tf-subnet"
  }
}

resource "aws_internet_gateway" "haider-tf-igw" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  tags = {
    Name = "haider-tf-igw"
  }
}

resource "aws_route_table" "haider-tf-rt" {
  vpc_id = aws_vpc.haider-tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.haider-tf-igw.id
  }

  tags = {
    Name = "haider-tf-rt"
  }
}

resource "aws_route_table_association" "haider-tf-rt-assoc" {
  subnet_id      = aws_subnet.haider-tf-subnet.id
  route_table_id = aws_route_table.haider-tf-rt.id

  depends_on = [aws_internet_gateway.haider-tf-igw]
}