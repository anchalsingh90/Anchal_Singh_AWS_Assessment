provider "aws" {
  region = "ap-south-1"
}

############################
# VPC
############################

resource "aws_vpc" "anchal_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Anchal_Singh_VPC"
  }
}

############################
# PUBLIC SUBNETS
############################

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.anchal_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Anchal_Singh_Public_Subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.anchal_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Anchal_Singh_Public_Subnet_2"
  }
}

############################
# PRIVATE SUBNETS
############################

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.anchal_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Anchal_Singh_Private_Subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.anchal_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Anchal_Singh_Private_Subnet_2"
  }
}

############################
# INTERNET GATEWAY
############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.anchal_vpc.id

  tags = {
    Name = "Anchal_Singh_IGW"
  }
}

############################
# PUBLIC ROUTE TABLE
############################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.anchal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Anchal_Singh_Public_RT"
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

############################
# NAT GATEWAY
############################

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "Anchal_Singh_NAT_EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Anchal_Singh_NAT_GW"
  }
}

############################
# PRIVATE ROUTE TABLE
############################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.anchal_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Anchal_Singh_Private_RT"
  }
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}

