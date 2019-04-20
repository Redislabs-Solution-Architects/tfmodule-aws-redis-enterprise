provider "aws" {
  region  = "us-east-1"
  profile = "redislabs"
}

module "mymodule" {
  source   = "../"
  profile  = "redislabs"
  region   = "us-east-1"
  open-nets = ["192.168.0.127/32"]
  vpc-cidr = "10.0.0.0/16"
  vpc-id = "vpc-12345678"
  common-tags = {
    "Owner"   = "maguec"
    "Project" = "example"
  }
}
