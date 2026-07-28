output "master_nodes_external_ip" {
  description = "Public IP addresses of master nodes"
  value = {
    for instance in yandex_compute_instance.k8s_master :
    instance.name => instance.network_interface[0].nat_ip_address
  }
}

output "master_nodes_internal_ip" {
  description = "Private IP addresses of master nodes"
  value = {
    for instance in yandex_compute_instance.k8s_master :
    instance.name => instance.network_interface[0].ip_address
  }
}

output "worker_nodes_external_ip" {
  description = "Public IP addresses of worker nodes"
  value = {
    for instance in yandex_compute_instance.k8s_worker :
    instance.name => instance.network_interface[0].nat_ip_address
  }
}

output "worker_nodes_internal_ip" {
  description = "Private IP addresses of worker nodes"
  value = {
    for instance in yandex_compute_instance.k8s_worker :
    instance.name => instance.network_interface[0].ip_address
  }
}

output "ansible_inventory" {
  description = "Inventory snippet for Kubespray / Ansible"
  value       = <<EOT
[kube_control_plane]
%{for instance in yandex_compute_instance.k8s_master~}
${instance.name} ansible_host=${instance.network_interface[0].nat_ip_address} ip=${instance.network_interface[0].ip_address}
%{endfor~}

[kube_node]
%{for instance in yandex_compute_instance.k8s_worker~}
${instance.name} ansible_host=${instance.network_interface[0].nat_ip_address} ip=${instance.network_interface[0].ip_address}
%{endfor~}

[etcd]
%{for instance in yandex_compute_instance.k8s_master~}
${instance.name} ansible_host=${instance.network_interface[0].nat_ip_address} ip=${instance.network_interface[0].ip_address}
%{endfor~}
EOT
}
