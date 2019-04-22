
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

variable "vpc-name" {
  description = "The Name of the VPC"
}

variable "vpc-subnets" {
  type        = list
  description = "The list of subnets available to the VPC"
}

variable "vpc-azs" {
  type        = list
  description = "The ID of the VPC"
}

variable "data-node-count" {
  description = "The number of RE data nodes"
  default     = 3
}

variable "re-instance-type" {
  description = "The size of instance to run"
  default     = "m5a.2xlarge"
}

variable "re-volume-size" {
  description = "The size of the two volumes to attach"
  default     = "150"
}