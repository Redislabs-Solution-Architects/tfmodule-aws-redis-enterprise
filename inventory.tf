resource "local_file" "instances_file" {
    filename = "../provisioners/${var.instances_inventory_file}"
    content = templatefile("../templates/inventory.tpl",
        {
            re_master_ip = "${aws_eip.re-eip.0.public_ip}"
            re_instance_hostnames = "${join("\n", (aws_instance.re.*.private_dns) )}"
            re_instance_ips = "${join("\n", (aws_eip.re-eip.*.public_ip) )}"
            re_node_ips = "${join("\n", slice( aws_eip.re-eip.*.public_ip, 1, length(aws_eip.re-eip.*.public_ip) ) )}"
            tester_ips = "${join("\n",(aws_eip.tester-eip.*.public_ip) )}"
            ssh_user = "${var.ssh-user}"
            cluster_size = "${var.data-node-count}"
            re_cluster_domain = "${var.cluster-prefix}.${var.zone-name}"
        })
}
