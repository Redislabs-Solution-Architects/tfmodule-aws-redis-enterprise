resource "aws_instance" "re" {
  count                  = var.data-node-count
  ami                    = data.aws_ami.re-ami.id
  instance_type          = var.re-instance-type
  availability_zone      = "${element(var.vpc-azs, count.index)}"
  subnet_id              = "${element(var.vpc-subnets, count.index)}"
  vpc_security_group_ids = [aws_security_group.re.id]
  source_dest_check      = false
  key_name               = "${var.vpc-name}"
  tags                   = merge({ Name = "${var.vpc-name}-private-${element(var.vpc-azs, count.index)}" }, var.common-tags)

}

resource "aws_ebs_volume" "re-ephemeral" {
  count             = var.data-node-count
  availability_zone = "${element(var.vpc-azs, count.index)}"
  size              = "${var.re-volume-size}"
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
}

resource "aws_volume_attachment" "re-persistant" {
  count       = var.data-node-count
  device_name = "/dev/sdj"
  volume_id   = "${element(aws_ebs_volume.re-persistant.*.id, count.index)}"
  instance_id = "${element(aws_instance.re.*.id, count.index)}"
}

