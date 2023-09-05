## A TF module to setup what's necessary to run Redis Enterprise
## To make this work, the following steps should be taken
* pull in this github
```bash
git clone https://github.com/jphaugla/tfmodule-aws-redis-enterprise.git
cd tfmodule-aws-redis-enterprise
```
* edit main.tf in the test subdirectory
  * most of these fields should be ensured to be correct
  * can see this is using default profile using .aws directory
```bash
cd test
vi main.tf
```
* terraform start
```bash
terraform init
terraform apply
```

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
