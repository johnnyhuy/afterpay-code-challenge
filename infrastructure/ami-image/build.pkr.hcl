source "amazon-ebs" "linux" {
  region = "ap-southeast-2"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    # AWS owned image
    owners      = ["099720109477"]
    most_recent = true
  }
  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "johnnyhuy/ubuntu-focal-20.04-amd64-server"

  tags = {
    Name        = "johnnyhuy-ubuntu-focal-20.04-amd64-server"
    Environment = "production"
    Application = "VM Stack"
  }
}
