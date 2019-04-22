[all]
${host_ip} ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -F /tmp/${vpc_name}_node_${ncount}.cfg'
