output "instance_public_ips" {
  description = "Public IPs of the created virtual machines"
  value = {
    for name, instance in yandex_compute_instance.nodes :
    name => instance.network_interface[0].nat_ip_address
  }
}

output "instance_private_ips" {
  description = "Private IPs of the created virtual machines"
  value = {
    for name, instance in yandex_compute_instance.nodes :
    name => instance.network_interface[0].ip_address
  }
}

output "ansible_inventory" {
  description = "Inventory content for ansible/inventory.ini"
  value = join("\n", concat(
    ["[docker_hosts]"],
    [
      for name in sort(var.instance_names) :
      format(
        "%s ansible_host=%s private_ip=%s",
        name,
        yandex_compute_instance.nodes[name].network_interface[0].nat_ip_address,
        yandex_compute_instance.nodes[name].network_interface[0].ip_address
      )
    ],
    [
      "",
      "[docker_hosts:vars]",
      "ansible_user=${var.vm_user}",
      "ansible_python_interpreter=/usr/bin/python3"
    ]
  ))
}
