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
  vpc-subnets      = ["subnet-047a071c39d0da64d"]
  vpc-id           = "vpc-016b00b2cedc31855"
  vpc-name         = "jph-prod-vpc"
  ssh-key          = "jphterra.pem"
  allow-public-ssh = 1
  enable-flash     = false
  enable-volumes   = false
  vpc-azs          = ["us-west-2a"]
  cluster-prefix   = "jphterra"
  zone-name        = "demo-rlec.redislabs.com"
  re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/6.2.18/redislabs-6.2.18-43-bionic-amd64.tar"
  common-tags = {
    "Owner"   = "jphaugla"
    "Project" = "jph-prod"
  }
}
