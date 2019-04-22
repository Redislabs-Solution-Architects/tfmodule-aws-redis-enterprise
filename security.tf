resource "aws_security_group" "re" {
  name        = "RedisEnterprise"
  description = "Redis Enterprise Security Group"
  vpc_id      = "${var.vpc-id}"
  tags        = merge({ Name = "RedisEnterprise-${var.vpc-name}" }, var.common-tags)
  ###############################################################################
  #                         Ingress
  ###############################################################################
  # SSH Internal
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # SSH External
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.open-nets
  }

  ###############################################################################
  #                         Redis Enterprise Specific
  # https://docs.redislabs.com/latest/rs/administering/designing-production/networking/port-configurations
  ###############################################################################

  # 	For connectivity checking between nodes
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc-cidr]
  }

  # Internal cluster usage
  ingress {
    from_port   = 3333
    to_port     = 3339
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  ingress {
    from_port   = 36379
    to_port     = 36380
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For application to access the RS Discovery Service
  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For secure (https) access to the management web UI
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For nginx <->cnm_http/cm communications on the same host only. Ports are bound to loopback adapter.
  ingress {
    from_port   = 8444
    to_port     = 8444
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }
  ingress {
    from_port   = 9080
    to_port     = 9080
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For CRDB management
  ingress {
    from_port   = 9081
    to_port     = 9081
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For metrics exported and managed by nginx
  ingress {
    from_port   = 8070
    to_port     = 8071
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # Used to expose the REST API, including cluster management and node bootstrap
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }
  ingress {
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For exposing databases externally
  ingress {
    from_port   = 10000
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = var.open-nets
  }

  # For internal communications with database shards
  ingress {
    from_port   = 20000
    to_port     = 29999
    protocol    = "tcp"
    cidr_blocks = [var.vpc-cidr]
  }

  # For accessing DNS/mDNS functionality in the cluster
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.vpc-cidr]
  }

  ingress {
    from_port   = 5353
    to_port     = 5353
    protocol    = "udp"
    cidr_blocks = [var.vpc-cidr]
  }

  ###############################################################################
  #                         Egress
  ###############################################################################

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
