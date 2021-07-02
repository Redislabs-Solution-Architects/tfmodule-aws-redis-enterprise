resource "aws_instance" "tester" {
  count                  = local.tester_count
  ami                    = data.aws_ami.re-ami.id
  instance_type          = var.tester-node-type
  availability_zone      = element(var.vpc-azs, count.index)
  subnet_id              = element(var.vpc-subnets, count.index)
  vpc_security_group_ids = [aws_security_group.re.id]
  source_dest_check      = false
  key_name               = local.ssh_key
  tags                   = merge({ Name = "RedisEnterprise-${var.vpc-name}-${count.index}" }, var.common-tags)

}

resource "aws_eip" "tester-eip" {
  vpc   = true
  count = local.tester_count
  tags  = merge({ Name = "${var.vpc-name}-node-eip-${count.index}" }, var.common-tags)
}

resource "aws_eip_association" "tester-eip-assoc" {
  count         = local.tester_count
  instance_id   = element(aws_instance.tester.*.id, count.index)
  allocation_id = element(aws_eip.tester-eip.*.id, count.index)
  depends_on    = [aws_instance.tester, aws_eip.tester-eip]
}
