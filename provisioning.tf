##########################################################################################
# ensure we can get to the node first
resource "null_resource" "remote-config" {
  count = var.data-node-count
  provisioner "remote-exec" {
    connection {
      user        = "ubuntu"
      host        = "${element(aws_eip.re-eip.*.public_ip, count.index)}"
      private_key = "${file(local.ssh_key_path)}"
      agent       = true
    }
    inline = ["sudo apt update > /dev/null  && sudo apt install -y python python-pip > /dev/null"]
  }
  depends_on = ["aws_instance.re", "aws_eip_association.re-eip-assoc", "null_resource.inventory-setup", "null_resource.ssh-setup"]
}

###############################################################################
# Template Data
data "template_file" "ansible_inventory" {
  count    = var.data-node-count
  template = "${file("${path.module}/inventory.tpl")}"
  vars = {
    host_ip  = "${element(aws_eip.re-eip.*.public_ip, count.index)}"
    vpc_name = "${var.vpc-name}"
    ncount   = "${count.index}"
  }
  depends_on = ["aws_instance.re", "aws_eip_association.re-eip-assoc", "aws_volume_attachment.re-ephemeral"]
}

data "template_file" "ssh_config" {
  template = "${file("${path.module}/ssh.tpl")}"
  vars = {
    vpc_name = "${var.vpc-name}"
  }
  depends_on = ["aws_instance.re", "aws_eip_association.re-eip-assoc", "aws_volume_attachment.re-ephemeral"]
}

###############################################################################
# Template Write
resource "null_resource" "inventory-setup" {
  count = var.data-node-count
  provisioner "local-exec" {
    command = "echo \"${element(data.template_file.ansible_inventory.*.rendered, count.index)}\" > /tmp/${var.vpc-name}_node_${count.index}.ini"
  }
  depends_on = ["data.template_file.ansible_inventory"]
}

resource "null_resource" "ssh-setup" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ssh_config.rendered}\" > /tmp/${var.vpc-name}_node.cfg"
  }
  depends_on = ["data.template_file.ssh_config"]
}

###############################################################################
# Run some ansible
resource "null_resource" "ansible-run" {
  count = var.data-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbook.yml --private-key ${local.ssh_key_path} -i /tmp/${var.vpc-name}_node_${count.index}.ini --become -e 'MYENV=1'"
  }
  depends_on = ["null_resource.remote-config"]
}



