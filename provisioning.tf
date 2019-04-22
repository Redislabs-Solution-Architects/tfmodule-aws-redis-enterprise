##########################################################################################
# ensure we can get to the node first
resource "null_resource" "remote-config" {
  count = var.data-node-count
  provisioner "remote-exec" {
    connection {
      user        = "ubuntu"
      host        = "${element(aws_instance.re.*.public_ip, count.index)}"
      private_key = "${file("~/.ssh/${var.vpc-name}.pem")}"
      agent       = true
    }
    inline = ["sudo apt update && sudo apt install -y python python-pip"]
  }
  depends_on = ["aws_instance.re", "aws_eip_association.re-eip-assoc", "null_resource.inventory-setup", "null_resource.ssh-setup"]
}

###############################################################################
# Template Data
data "template_file" "ansible_inventory" {
  count = var.data-node-count
  template = "${file("${path.module}/inventory.tpl")}"
  vars = {
    host_ip  = "${element(aws_instance.re.*.public_ip, count.index)}"
    vpc_name = "${var.vpc-name}"
    ncount   = "${count.index}"
  }
}

data "template_file" "ssh_config" {
  count = var.data-node-count
  template = "${file("${path.module}/ssh.tpl")}"
  vars = {
    host_ip  = "${element(aws_instance.re.*.public_ip, count.index)}"
    vpc_name = "${var.vpc-name}"
    ncount   = "${count.index}"
  }
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
  count = var.data-node-count
  provisioner "local-exec" {
    command = "echo \"${element(data.template_file.ssh_config.*.rendered, count.index)}\" > /tmp/${var.vpc-name}_node_${count.index}.cfg"
  }
  depends_on = ["data.template_file.ssh_config"]
}

###############################################################################
# Run some ansible
resource "null_resource" "ansible-run" {
  count = var.data-node-count
  provisioner "local-exec" {
    command = "ansible-playbook ${path.module}/ansible/playbook.yml --private-key ~/.ssh/${var.vpc-name}.pem -i /tmp/${var.vpc-name}_node_${count.index}.ini --become -e 'MYENV=1'"
  }
  depends_on = ["null_resource.remote-config"]
}



