resource "aws_instance" "a" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type 64-bit x86
  ami                         = "ami-0f158b0f26f18e619"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true

  tags = merge(
    {
      Name = "afterpay-vm-a"
    },
    local.tags
  )
}

resource "aws_instance" "b" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type 64-bit x86
  ami                         = "ami-0f158b0f26f18e619"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_b.id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true

  tags = merge(
    {
      Name = "afterpay-vm-b"
    },
    local.tags
  )
}

resource "aws_instance" "c" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type 64-bit x86
  ami                         = "ami-0f158b0f26f18e619"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_c.id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true

  tags = merge(
    {
      Name = "afterpay-vm-c"
    },
    local.tags
  )
}
