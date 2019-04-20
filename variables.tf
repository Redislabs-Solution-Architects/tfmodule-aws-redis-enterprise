
variable "profile" {
  description = "The AWS profile to use"
}

variable "region" {
  description = "The AWS region to run in"
}

variable "common-tags" {
  type        = map(string)
  description = "Tags that go everywhere"
}

variable "open-nets" {
  type        = list
  description = "CIDRs that will have access to everything"
}

variable "vpc-cidr" {
  description = "The CIDR of the VPC"
}

variable "vpc-id" {
  description = "The ID of the VPC"
}