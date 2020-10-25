resource "aws_key_pair" "worker" {
  key_name   = "worker"
  public_key = file("./identity.pem.pub")

  tags = merge(
    {
      Name = "afterpay-worker-ssh"
    },
    local.tags
  )
}

resource "aws_instance" "a" {
  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type 64-bit x86
  ami                         = "ami-0f158b0f26f18e619"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.worker.key_name

  tags = merge(
    {
      Name = "afterpay-worker-a-vm"
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
  key_name                    = aws_key_pair.worker.key_name

  tags = merge(
    {
      Name = "afterpay-worker-b-vm"
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
  key_name                    = aws_key_pair.worker.key_name

  tags = merge(
    {
      Name = "afterpay-worker-c-vm"
    },
    local.tags
  )
}

resource "ansible_host" "a" {
  inventory_hostname = aws_instance.a.public_dns
  groups             = ["public"]
  vars = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = "./identity.pem"
  }
}

resource "ansible_host" "b" {
  inventory_hostname = aws_instance.b.public_dns
  groups             = ["public"]
  vars = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = "./identity.pem"
  }
}

resource "ansible_host" "c" {
  inventory_hostname = aws_instance.c.public_dns
  groups             = ["public"]
  vars = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = "./identity.pem"
  }
}
