provider "aws" {
  region  = "us-west-1"
  profile = "default"
  shared_config_files      = ["/Users/jasonhaugland/.aws/conf"]
  shared_credentials_files = ["/Users/jasonhaugland/.aws/creds"]
}

module "mymodule" {
  source           = "../"
  region           = "us-west-1"
  profile          = "default"
  open-nets        = ["174.141.204.19/32"]
  data-node-count  = 3
  vpc-cidr         = "10.1.0.0/16"
  vpc-subnet       = "jph-prod-subnet-public-1"
  vpc-name         = "jph-prod-vpc"
  ssh-key          = "jph_uswest1.pem"
  allow-public-ssh = 1
  re-instance-type = "t2.2xlarge"
  tester-node-type = "t2.xlarge"
  enable-flash     = false
  enable-volumes   = false
  vpc-azs          = "us-west-1a"
  cluster-prefix   = "jphterra1"
  zone-name        = "demo-rlec.redislabs.com"
 re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/6.4.2/redislabs-6.4.2-81-bionic-amd64.tar"
  common-tags = {
    "Owner"   = "jphaugla"
    "Project" = "jph-prod"
  }
}
