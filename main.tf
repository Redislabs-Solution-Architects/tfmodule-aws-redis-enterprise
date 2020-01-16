provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}

# Allow us to enable flash devices
locals {
  count_flash = (var.enable-flash == true ? var.data-node-count : 0)
}
