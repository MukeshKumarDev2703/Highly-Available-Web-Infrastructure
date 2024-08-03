## VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-vpc"
    }
  )
}

data "aws_availability_zones" "available_zones" {}

## Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

## Nat Gateway EIP
resource "aws_eip" "eip_nat" {
  domain     = "vpc"
  depends_on = [aws_vpc.main]
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-nat-gw-eip"
    }
  )
}

## Nat Gateway main
resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_internet_gateway.main_igw]
  allocation_id = aws_eip.eip_nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-nat-gateway"
    }
  )
}

## VPC Public Subnets
resource "aws_subnet" "public_subnet" {
  count      = length(var.vpc_public_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.vpc_public_subnets, count.index)
  #availability_zone = element(var.vpc_availability_zones, count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = var.map_public_ip
  tags = {
    "Name" = "${local.name_prefix}-public-subnet-${count.index + 1}"
  }
}

## VPC Private Subnets
resource "aws_subnet" "private_subnet" {
  count      = length(var.vpc_private_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.vpc_private_subnets, count.index)
  #availability_zone = element(var.vpc_availability_zones, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-private-subnet-${count.index + 1}"
    }
  )
}

## VPC Database Subnets
resource "aws_subnet" "database_subnet" {
  count      = length(var.vpc_db_subnets)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.vpc_db_subnets, count.index)
  #availability_zone = element(var.vpc_availability_zones, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-database-subnet-${count.index + 1}"
    }
  )
}
## VPC Route Table for Database subnets
resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-database-subnet-rt"
    }
  )
}

## VPC Route Table Association for Database Subnets
resource "aws_route_table_association" "database_rt_association" {
  count          = length(var.vpc_db_subnets)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_rt.id
}

## VPC Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-public-subnet-rt"
    }
  )
}

## VPC Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-private-subnet-rt"
    }
  )
}

## VPC Route Table Association for Public Subnets
resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.vpc_public_subnets)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

## VPC Route Table Association for Private Subnets
resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.vpc_private_subnets)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

## VPC Database Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = aws_subnet.database_subnet[*].id
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-database-subnet-group"
    }
  )
}
