provider "aws" {
  region  = "us-east-1"
  profile = "redislabs"
}

module "mymodule" {
  source           = "../"
  profile          = "redislabs"
  region           = "us-east-1"
  open-nets        = ["192.168.0.127/32"]
  data-node-count  = 3
  vpc-cidr         = "10.0.0.0/16"
  vpc-subnets      = ["subnet-1", "subnet-2"]
  vpc-id           = "vpc-12345678"
  vpc-name         = "myvpc"
  ssh-key          = "test.pem"
  allow-public-ssh = 1
  vpc-azs          = ["us-west-1a", "us-west-1b"]
  common-tags      = {
    "Owner"        = "maguec"
    "Project"      = "example"
  }
}
