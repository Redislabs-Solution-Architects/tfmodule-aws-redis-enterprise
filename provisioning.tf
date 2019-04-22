resource "null_resource" "remote-config" {
  count = var.data-node-count
  provisioner "remote-exec" {
    connection {
      user        = "ubuntu"
      host        = "${element(aws_instance.re.*.public_ip, count.index)}"
      private_key = "${file("~/.ssh/${var.vpc-name}.pem")}"
      agent       = true
    }
    inline = ["hostname"]
  }
  depends_on = ["aws_instance.re", "aws_eip_association.re-eip-assoc"]
}
