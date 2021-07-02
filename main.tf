provider "aws" {
  region  = var.region
  profile = var.profile
}

# Allow us to configure volumes
locals {
  count_volumes = (var.enable-volumes == true ? var.data-node-count : 0)
}

# Allow us to enable flash devices
locals {
  count_flash = (var.enable-flash == true ? var.data-node-count : 0)
}

locals {
  ssh_key_path = (var.ssh-key == "" ? "~/.ssh/${var.vpc-name}.pem" : "~/.ssh/${replace(var.ssh-key, ".pem", "")}.pem")
}


locals {
  ssh_key = (var.ssh-key == "" ? var.vpc-name : replace(var.ssh-key, ".pem", ""))
}


# if the tester-node-type is set add a tester node
locals {
  tester_count = (var.tester-node-type == "" ? 0 : 1)
}
