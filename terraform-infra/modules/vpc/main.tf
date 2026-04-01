
# VPC

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

 tags = merge(
    { Name = "${var.environment}-${var.project}-${var.vpc_name}" },
    var.tags
  )
}

# Internet Gateway

resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    { Name = "${var.environment}-${var.project}-ig" },
    var.tags
  )
}

# Public Subnets

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnet_azs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    { Name = "${var.environment}-${var.project}-public-${count.index + 1}" },
    var.tags
  )
}

# Public Route Table

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(
    { Name = "${var.environment}-${var.project}-public-rt" },
    var.tags
  )
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_ig.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnet_azs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


# Private Subnets

resource "aws_subnet" "private_frontend_subnet" {
  count             = length(var.private_subnet_azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_frontend_cidr[count.index]
  availability_zone = var.private_subnet_azs[count.index]

  tags = merge(
    { Name = "${var.environment}-${var.project}-frontend-${count.index + 1}" },
    var.tags
  )
}

resource "aws_subnet" "private_backend_subnet" {
  count             = length(var.private_subnet_azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_backend_cidr[count.index]
  availability_zone = var.private_subnet_azs[count.index]

  tags = merge(
    { Name = "${var.environment}-${var.project}-backend-${count.index + 1}" },
    var.tags
  )
}

resource "aws_subnet" "private_database_subnet" {
  count             = length(var.private_subnet_azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_database_cidr[count.index]
  availability_zone = var.private_subnet_azs[count.index]

  tags = merge(
    { Name = "${var.environment}-${var.project}-database-${count.index + 1}" },
    var.tags
  )
}


# NAT Gateways

resource "aws_eip" "nat_eip" {
  count  = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  domain = "vpc"

  tags = merge(
    { Name = "${var.environment}-${var.project}-nat-eip-${count.index + 1}" },
    var.tags
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = merge(
    { Name = "${var.environment}-${var.project}-nat-${count.index + 1}" },
    var.tags
  )
}


# Frontend Route Tables

resource "aws_route_table" "frontend_rt" {
  count  = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "frontend_nat_route" {
  count                  = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  route_table_id         = aws_route_table.frontend_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "frontend_assoc" {
  count          = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  subnet_id      = aws_subnet.private_frontend_subnet[count.index].id
  route_table_id = aws_route_table.frontend_rt[count.index].id
}


# Backend Route Tables

resource "aws_route_table" "backend_rt" {
  count  = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route" "backend_nat_route" {
  count                  = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  route_table_id         = aws_route_table.backend_rt[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "backend_assoc" {
  count          = var.enable_nat_gateway ? length(var.private_subnet_azs) : 0
  subnet_id      = aws_subnet.private_backend_subnet[count.index].id
  route_table_id = aws_route_table.backend_rt[count.index].id
}


# Database Route Table (NO INTERNET)

resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table_association" "database_assoc" {
  count          = length(var.private_subnet_azs)
  subnet_id      = aws_subnet.private_database_subnet[count.index].id
  route_table_id = aws_route_table.database_rt.id
}
