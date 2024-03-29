resource "aws_instance" "re" {
  count                  = var.data-node-count
  ami                    = data.aws_ami.re-ami.id
  instance_type          = var.re-instance-type
  availability_zone      = var.vpc-azs
  subnet_id              = aws_subnet.region_subnet.id
  vpc_security_group_ids = [aws_security_group.re.id]
  source_dest_check      = false
  key_name               = local.ssh_key
  root_block_device { volume_size = var.node-root-size }
  tags = merge({ Name = "RedisEnterprise-${var.vpc-name}-${count.index}" }, var.common-tags)

}

resource "aws_eip" "re-eip" {
  domain = "vpc"
  count  = var.data-node-count
  tags   = merge({ Name = "${var.vpc-name}-node-eip-${count.index}" }, var.common-tags)
}

resource "aws_eip_association" "re-eip-assoc" {
  count         = var.data-node-count
  instance_id   = element(aws_instance.re.*.id, count.index)
  allocation_id = element(aws_eip.re-eip.*.id, count.index)
  depends_on    = [aws_instance.re, aws_eip.re-eip]
}

# Handle attaching volumes if enable-volumes is set (true by default)

resource "aws_ebs_volume" "re-ephemeral" {
  count             = local.count_volumes
  availability_zone = var.vpc-azs
  size              = var.re-volume-size
  tags              = merge({ Name = "ephemeral-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-ephemeral" {
  count       = local.count_volumes
  device_name = "/dev/xvdh"
  volume_id   = element(aws_ebs_volume.re-ephemeral.*.id, count.index)
  instance_id = element(aws_instance.re.*.id, count.index)
}

resource "aws_ebs_volume" "re-persistant" {
  count             = local.count_volumes
  availability_zone = var.vpc-azs
  size              = var.re-volume-size
  tags              = merge({ Name = "persistant-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-persistant" {
  count       = local.count_volumes
  device_name = "/dev/xvdj"
  volume_id   = element(aws_ebs_volume.re-persistant.*.id, count.index)
  instance_id = element(aws_instance.re.*.id, count.index)
}

# Handle attaching volumes if enable-flash is set (false by default)

resource "aws_ebs_volume" "re-flash" {
  count             = local.count_flash
  availability_zone = var.vpc-azs
  size              = var.re-volume-size
  type              = "gp2"
  tags              = merge({ Name = "flash-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-flash" {
  count       = local.count_flash
  device_name = "/dev/xvdi"
  volume_id   = element(aws_ebs_volume.re-flash.*.id, count.index)
  instance_id = element(aws_instance.re.*.id, count.index)
}
