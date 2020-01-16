## A TF module to setup what's necessary to run Redis Enterprise

Sourcing the module:

```
module "nodes" {
  source           = "github.com/Redislabs-Solution-Architects/tfmodule-aws-redis-enterprise"
  region           = var.region
  profile          = var.profile
  open-nets        = ["1.1.1.1/32", "8.8.8.8/32"] 	#external IPs allowed unfettered access - use w/ caution
  data-node-count  = 3
  re-instance-type = "m5.4xlarge"
  vpc-cidr         = var.vpc-cidr
  vpc-azs          = var.vpc-azs
  vpc-name         = var.vpc-name
  vpc-id           = module.vpc.vpc-id
  vpc-subnets      = module.vpc.subnets-public
  common-tags = {					#tags that go everywhere - you do tag everything right?
    "Owner"   = "maguec"
    "Project" = "example_terraform"
  }
}
```
