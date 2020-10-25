# TODO: make a management console to deploy Ansible changes instead of our local machines
# resource "aws_instance" "mc" {
#   # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type 64-bit x86
#   ami                         = "ami-0f158b0f26f18e619"
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.public_a.id
#   vpc_security_group_ids      = [aws_security_group.vm.id]
#   associate_public_ip_address = true

#   tags = merge(
#     {
#       Name = "afterpay-vm-a"
#     },
#     local.tags
#   )
# }
