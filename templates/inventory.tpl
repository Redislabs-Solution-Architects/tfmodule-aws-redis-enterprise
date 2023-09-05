[re_master]
${re_master_ip}

[re_master:vars]
cluster_domain=${re_cluster_domain}

[re_nodes]
${re_node_ips}

[re_nodes:vars]
cluster_size=${cluster_size}

[all_node_names]
${re_instance_hostnames}

[all_node_ips]
${re_instance_ips}

[tester_node_ips]
${tester_ips}

[all:vars]
ansible_connection=ssh
ansible_user=${ssh_user}
