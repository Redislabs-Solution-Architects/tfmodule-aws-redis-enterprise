##########################################################################################
resource "null_resource" "provision" {

    triggers = {
        always_run = "${timestamp()}"
    }

    provisioner "local-exec" {
        working_dir = "../provisioners/"
        command = "ansible-playbook -i '${var.instances_inventory_file}' --private-key ${local.ssh_key_path} playbook.yml ${var.ansible_verbosity_switch} -e 'S3_RE_BINARY=${var.re-download-url}'  -e 'ENABLE_VOLUMES=${var.enable-volumes}' -e 'ENABLE_FLASH=${var.enable-flash}'"
    }

    depends_on = [
aws_eip.re-eip, aws_instance.re, aws_eip.tester-eip
    ]
}
