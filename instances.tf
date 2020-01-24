resource "aws_instance" "re" {
  count                  = var.data-node-count
  ami                    = data.aws_ami.re-ami.id
  instance_type          = var.re-instance-type
  availability_zone      = "${element(var.vpc-azs, count.index)}"
  subnet_id              = "${element(var.vpc-subnets, count.index)}"
  vpc_security_group_ids = [aws_security_group.re.id]
  source_dest_check      = false
  key_name               = "${var.vpc-name}"
  tags                   = merge({ Name = "RedisEnterprise-${var.vpc-name}-${count.index}" }, var.common-tags)

}

resource "aws_ebs_volume" "re-ephemeral" {
  count             = var.data-node-count
  availability_zone = "${element(var.vpc-azs, count.index)}"
  size              = "${var.re-volume-size}"
  tags              = merge({ Name = "ephemeral-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-ephemeral" {
  count       = var.data-node-count
  device_name = "/dev/sdh"
  volume_id   = "${element(aws_ebs_volume.re-ephemeral.*.id, count.index)}"
  instance_id = "${element(aws_instance.re.*.id, count.index)}"
}

resource "aws_ebs_volume" "re-persistant" {
  count             = var.data-node-count
  availability_zone = "${element(var.vpc-azs, count.index)}"
  size              = "${var.re-volume-size}"
  tags              = merge({ Name = "persistant-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-persistant" {
  count       = var.data-node-count
  device_name = "/dev/sdj"
  volume_id   = "${element(aws_ebs_volume.re-persistant.*.id, count.index)}"
  instance_id = "${element(aws_instance.re.*.id, count.index)}"
}

resource "aws_ebs_volume" "re-flash" {
  count = local.count_flash
  availability_zone = "${element(var.vpc-azs, count.index)}"
  size              = "${var.re-volume-size}"
  type              = "io1"
  iops              = var.flash-iops
  tags              = merge({ Name = "flash-${var.vpc-name}-${count.index}" }, var.common-tags)
}

resource "aws_volume_attachment" "re-flash" {
  count       = local.count_flash
  device_name = "/dev/sdi"
  volume_id   = "${element(aws_ebs_volume.re-flash.*.id, count.index)}"
  instance_id = "${element(aws_instance.re.*.id, count.index)}"
}

resource "aws_eip" "re-eip" {
  vpc   = true
  count = var.data-node-count
  tags  = merge({ Name = "${var.vpc-name}-node-eip-${count.index}" }, var.common-tags)
}

resource "aws_eip_association" "re-eip-assoc" {
  count         = var.data-node-count
  instance_id   = "${element(aws_instance.re.*.id, count.index)}"
  allocation_id = "${element(aws_eip.re-eip.*.id, count.index)}"
  depends_on    = ["aws_instance.re", "aws_eip.re-eip"]
}
