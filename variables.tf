
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
  default = []
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

variable "ssh-key" {
  description = "Set if the SSH key you wish to use does not match the VPC name"
  default = ""
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
  default     = "t2.2xlarge"
}

variable "re-volume-size" {
  description = "The size of the two volumes to attach"
  default     = "150"
}

variable "enable-flash" {
  description = "Enable Flash Devices"
  default     = false
}

variable "enable-volumes" {
  description = "Enable EBS Devices for Ephemeral and Persistent storage"
  default     = true
}

variable "flash-iops" {
  description = "Enable Flash IOPS"
  default     = "100"
  }

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - disabled by default"
  default     = "0"
  }

variable "internal-rules" {
  description = "Security rules to allow for connectivity within the VPC"
  type = list
  default = [
    {
      type = "ingress"
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      comment   = "SSH from VPC"
    },
    {
      type = "ingress"
      from_port = "1968"
      to_port   = "1968"
      protocol  = "tcp"
      comment   = "Proxy traffic (Internal use)"
    },
    {
      type = "ingress"
      from_port = "3333"
      to_port   = "3339"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type = "ingress"
      from_port = "36379"
      to_port   = "36380"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type = "ingress"
      from_port = "8001"
      to_port   = "8001"
      protocol  = "tcp"
      comment   = "Traffic from application to RS Discovery Service"
    },
    {
      type = "ingress"
      from_port = "8443"
      to_port   = "8443"
      protocol  = "tcp"
      comment   = "Secure (HTTPS) access to the management web UI"
    },
    {
      type = "ingress"
      from_port = "8444"
      to_port   = "8444"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type = "ingress"
      from_port = "9080"
      to_port   = "9080"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type = "ingress"
      from_port = "9081"
      to_port   = "9081"
      protocol  = "tcp"
      comment   = "For CRDB management (Internal use)"
    },
    {
      type = "ingress"
      from_port = "8070"
      to_port   = "8071"
      protocol  = "tcp"
      comment   = "Prometheus metrics exporter"
    },
    {
      type = "ingress"
      from_port = "9443"
      to_port   = "9443"
      protocol  = "tcp"
      comment   = "REST API traffic, including cluster management and node bootstrap"
    },
    {
      type = "ingress"
      from_port = "10000"
      to_port   = "19999"
      protocol  = "tcp"
      comment   = "Database traffic - if manually creating db ports pare down"
    },
    {
      type = "ingress"
      from_port = "20000"
      to_port   = "29999"
      protocol  = "tcp"
      comment   = "Database shards traffic - if manually creating db ports pare down"
    },
    {
      type = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type = "ingress"
      from_port = "5353"
      to_port   = "5353"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type = "ingress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type = "egress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      comment   = "Let TCP out to the VPC"
    },
    {
      type = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      comment   = "Let UDP out to the VPC"
    },
    {
      type = "ingress"
      from_port = "8301"
      to_port   = "8301"
      protocol  = "udp"
      comment   = "Consul Traffic Gossip"
    },
    {
      type = "ingress"
      from_port = "8301"
      to_port   = "8301"
      protocol  = "tcp"
      comment   = "Consul Traffic Gossip"
    },
    {
      type = "ingress"
      from_port = "8600"
      to_port   = "8600"
      protocol  = "tcp"
      comment   = "Consul Traffic DNS"
    },
    {
      type = "ingress"
      from_port = "8600"
      to_port   = "8600"
      protocol  = "udp"
      comment   = "Consul Traffic DNS"
    },
    {
      type = "ingress"
      from_port = "8400"
      to_port   = "8400"
      protocol  = "tcp"
      comment   = "Consul Traffic RPC"
    },
    {
      type = "ingress"
      from_port = "8500"
      to_port   = "8500"
      protocol  = "tcp"
      comment   = "Consul Traffic HTTP"
    },
    {
      type = "ingress"
      from_port = "8300"
      to_port   = "8300"
      protocol  = "tcp"
      comment   = "Consul Traffic Internal"
    },
    ]
  }

variable "external-rules" {
  description = "Security rules to allow for connectivity external to the VPC"
  type = list
  default = [
    {
      type = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    }
    ]
  }

