resource "aws_security_group" "re" {
  name        = "RedisEnterprise"
  description = "Redis Enterprise Security Group"
  vpc_id      = "${var.vpc-id}"
  tags        = merge({ Name = "RedisEnterprise-${var.vpc-name}" }, var.common-tags)
}

resource "aws_security_group_rule" "internal_rules" {
  count             = length(var.internal-rules)
  type              = "${lookup(var.internal-rules[count.index], "type")}"
  from_port         = "${lookup(var.internal-rules[count.index], "from_port")}"
  to_port           = "${lookup(var.internal-rules[count.index], "to_port")}"
  protocol          = "${lookup(var.internal-rules[count.index], "protocol")}"
  cidr_blocks       = [var.vpc-cidr]
  security_group_id = "${aws_security_group.re.id}"
}

resource "aws_security_group_rule" "external_rules" {
  count             = length(var.external-rules)
  type              = "${lookup(var.external-rules[count.index], "type")}"
  from_port         = "${lookup(var.external-rules[count.index], "from_port")}"
  to_port           = "${lookup(var.external-rules[count.index], "to_port")}"
  protocol          = "${lookup(var.external-rules[count.index], "protocol")}"
  cidr_blocks       = "${lookup(var.external-rules[count.index], "cidr")}"
  security_group_id = "${aws_security_group.re.id}"
}

resource "aws_security_group_rule" "open_nets" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "all"
  cidr_blocks       = var.open-nets
  security_group_id = "${aws_security_group.re.id}"
}

resource "aws_security_group_rule" "allow_public_ssh" {
  count             = var.allow-public-ssh
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.re.id}"
}
