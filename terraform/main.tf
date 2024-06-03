locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "random_id" "this" {
  byte_length = 2
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cdir
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terran_vpc-${random_id.this.dec}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terran_igw-${random_id.this.dec}"
  }
}

resource "aws_route_table" "terran_public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "terran-public"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.terran_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_default_route_table" "terran_private_rt" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name = "terran-private"
  }
}

resource "aws_subnet" "public" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cdir, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "terran-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cdir, 8, length(local.azs) + count.index)
  map_public_ip_on_launch = false
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "terran-private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.azs)
  route_table_id = aws_route_table.terran_public_rt.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_security_group" "public" {
  name        = "public_sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.this.id
}
resource "aws_vpc_security_group_ingress_rule" "ingress_all" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4 = var.access_ip
  ip_protocol = -1
}
resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}
