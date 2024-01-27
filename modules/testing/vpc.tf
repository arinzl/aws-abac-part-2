resource "aws_vpc" "main" {
  tags = {
    Name = "demo"
  }
  cidr_block = var.cidr_block_module

  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name : "demo-abac-private-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_route_table" "private" {

  tags = {
    Name = "demo-private-${data.aws_availability_zones.available.names[1]}"
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {

  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

