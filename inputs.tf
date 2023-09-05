data "aws_ami" "re-ami" {
  most_recent = true
  name_regex  = "ubuntu\\/images\\/hvm-ssd\\/ubuntu-bionic-18.04-amd64-server"
  # This is Canonical's ID
  owners = ["099720109477"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

#  filter {
#    name   = "ena-support"
#    values = [var.ena-support]
#  }
}
data "aws_ami" "tst-ami" {
  most_recent = true
  name_regex  = "ubuntu\\/images\\/hvm-ssd\\/ubuntu-jammy-22.04-amd64-server"
  # This is Canonical's ID
  owners = ["099720109477"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
