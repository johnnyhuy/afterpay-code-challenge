resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "afterpay-igw"
    },
    local.tags
  )
}

resource "aws_vpc" "this" {
  cidr_block           = cidrsubnet("10.0.0.0/16", 4, 1)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "afterpay-vpc"
    },
    local.tags
  )
}

resource "aws_subnet" "public_a" {
  availability_zone       = "ap-southeast-2a"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 4, 1)

  tags = merge(
    {
      Name = "afterpay-subnet-a"
    },
    local.tags
  )
}

resource "aws_subnet" "public_b" {
  availability_zone       = "ap-southeast-2b"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 4, 2)

  tags = merge(
    {
      Name = "afterpay-subnet-b"
    },
    local.tags
  )
}

resource "aws_subnet" "public_c" {
  availability_zone       = "ap-southeast-2c"
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 4, 3)

  tags = merge(
    {
      Name = "afterpay-subnet-c"
    },
    local.tags
  )
}

resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.this.main_route_table_id

  tags = merge(
    {
      Name = "afterpay-public"
    },
    local.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_default_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_default_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_default_route_table.public.id
}
