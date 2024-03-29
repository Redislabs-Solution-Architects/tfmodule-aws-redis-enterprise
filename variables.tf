
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

variable "instances_inventory_file" {
    description = "Path and file name to send inventory details for ansible later."
    default = "inventory"
}

variable "ssh-user" {
    description = "username for ssh.  This is currently not changeable as it is the default"
    default = "ubuntu"
}
variable "open-nets" {
  type        = list(any)
  description = "CIDRs that will have access to everything"
  default     = []
}

variable "vpc-cidr" {
  description = "The CIDR of the VPC"
}

variable "ansible_verbosity_switch" {
    description = "Set the about of verbosity to pass through to the ansible playbook command. No additional verbosity by default. Example: -v or -vv or -vvv."
    default = "-vv"
}

variable "vpc-name" {
  description = "The Name of the VPC"
}

variable "ssh-key" {
  description = "Set if the SSH key you wish to use does not match the VPC name"
  default     = ""
}


variable "vpc-subnet" {
  description = "The subnet available to the VPC"
}

variable "vpc-azs" {
  description = "The availability zone of the region"
}

variable "cluster-prefix" {
  description = "the cluster prefix before the zone-name"
}

variable "zone-name" {
  description = "the route 53 zone name"
}

variable "data-node-count" {
  description = "The number of RE data nodes"
  default     = 3
}

variable "re-instance-type" {
  description = "The size of instance to run"
  default     = "t2.2xlarge"
}

variable "ena-support" {
  description = "choose AMIs that have ENA support enabled"
  default     = false
}

variable "tester-node-type" {
  description = "Set this to a type if you want to run a tester node"
  default     = "t2.xlarge"
}

variable "quorum-node-type" {
  description = "Set this to a type if you want to use a quorum node"
  default     = ""
}

variable "re-volume-size" {
  description = "The size of the two volumes to attach"
  default     = "150"
}

variable "node-root-size" {
  description = "The size of the instances root volume"
  default     = "50"
}

variable "tester-root-size" {
  description = "The size of the tester root volume"
  default     = "50"
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

# Use this to determine what version of the software gets installed
variable "re-download-url" {
  description = "The download link for the redis enterprise software"
  default     = null
}

variable "internal-rules" {
  description = "Security rules to allow for connectivity within the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "22"
      to_port   = "22"
      protocol  = "tcp"
      comment   = "SSH from VPC"
    },
    {
      type      = "ingress"
      from_port = "1968"
      to_port   = "1968"
      protocol  = "tcp"
      comment   = "Proxy traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3333"
      to_port   = "3341"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "3343"
      to_port   = "3344"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "36379"
      to_port   = "36380"
      protocol  = "tcp"
      comment   = "Cluster traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8001"
      to_port   = "8001"
      protocol  = "tcp"
      comment   = "Traffic from application to RS Discovery Service"
    },
    {
      type      = "ingress"
      from_port = "8002"
      to_port   = "8002"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8004"
      to_port   = "8004"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8006"
      to_port   = "8006"
      protocol  = "tcp"
      comment   = "System health monitoring"
    },
    {
      type      = "ingress"
      from_port = "8443"
      to_port   = "8443"
      protocol  = "tcp"
      comment   = "Secure (HTTPS) access to the management web UI"
    },
    {
      type      = "ingress"
      from_port = "8444"
      to_port   = "8444"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9080"
      to_port   = "9080"
      protocol  = "tcp"
      comment   = "nginx <-> cnm_http/cm traffic (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "9081"
      to_port   = "9081"
      protocol  = "tcp"
      comment   = "For CRDB management (Internal use)"
    },
    {
      type      = "ingress"
      from_port = "8070"
      to_port   = "8071"
      protocol  = "tcp"
      comment   = "Prometheus metrics exporter"
    },
    {
      type      = "ingress"
      from_port = "9443"
      to_port   = "9443"
      protocol  = "tcp"
      comment   = "REST API traffic, including cluster management and node bootstrap"
    },
    {
      type      = "ingress"
      from_port = "10000"
      to_port   = "19999"
      protocol  = "tcp"
      comment   = "Database traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "20000"
      to_port   = "29999"
      protocol  = "tcp"
      comment   = "Database shards traffic - if manually creating db ports pare down"
    },
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "5353"
      to_port   = "5353"
      protocol  = "udp"
      comment   = "DNS Traffic"
    },
    {
      type      = "ingress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "-1"
      to_port   = "-1"
      protocol  = "icmp"
      comment   = "Ping for connectivity checks between nodes"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      comment   = "Let TCP out to the VPC"
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      comment   = "Let UDP out to the VPC"
    },
    #    {
    #      type      = "ingress"
    #      from_port = "8080"
    #      to_port   = "8080"
    #      protocol  = "tcp"
    #      comment   = "Allow for host check between nodes"
    #    },
  ]
}

variable "external-rules" {
  description = "Security rules to allow for connectivity external to the VPC"
  type        = list(any)
  default = [
    {
      type      = "ingress"
      from_port = "53"
      to_port   = "53"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "tcp"
      cidr      = ["0.0.0.0/0"]
    },
    {
      type      = "egress"
      from_port = "0"
      to_port   = "65535"
      protocol  = "udp"
      cidr      = ["0.0.0.0/0"]
    }
  ]
}

