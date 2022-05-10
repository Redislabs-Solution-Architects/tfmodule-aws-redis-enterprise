provider "aws" {
  region  = "us-west-2"
  profile = "default"
  shared_config_files      = ["/Users/jasonhaugland/.aws/conf"]
  shared_credentials_files = ["/Users/jasonhaugland/.aws/creds"]
}

module "mymodule" {
  source           = "../"
  region           = "us-west-2"
  profile          = "default"
  open-nets        = ["174.141.204.19/32"]
  data-node-count  = 3
  vpc-cidr         = "10.1.0.0/16"
  vpc-subnets      = ["subnet-0d706029a98886e55"]
  vpc-id           = "vpc-0c1deef36f8f4451d"
  vpc-name         = "jph-prod-vpc"
  ssh-key          = "jphterra.pem"
  allow-public-ssh = 1
  enable-flash     = false
  enable-volumes   = false
  vpc-azs          = ["us-west-2a"]
  cluster-prefix   = "jphterra"
  zone-name        = "demo-rlec.redislabs.com"
  common-tags = {
    "Owner"   = "jphaugla"
    "Project" = "jph-prod"
  }
}
