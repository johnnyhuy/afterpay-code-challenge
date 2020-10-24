resource "aws_security_group" "vm" {
  name        = "vm-sg"
  description = "Alow inbound access to the VM."
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.load_balancer.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(
    {
      Name = "afterpay-vm-sg"
    },
    local.tags
  )
}

resource "aws_security_group" "load_balancer" {
  name        = "load-balancer-sg"
  description = "Allow internet ingress from the load balancer."
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TODO: HTTPS setup
  # ingress {
  #   protocol    = "tcp"
  #   from_port   = 443
  #   to_port     = 443
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      # Public subnets
      cidrsubnet(aws_vpc.this.cidr_block, 4, 1),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 2),
      cidrsubnet(aws_vpc.this.cidr_block, 4, 3)
    ]
  }

  tags = merge(
    {
      Name = "afterpay-load-balancer-sg"
    },
    local.tags
  )
}
