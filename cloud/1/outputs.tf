output "nat_instance" {
  description = "NAT instance connection details"
  value = {
    name        = yandex_compute_instance.nat_instance.name
    internal_ip = yandex_compute_instance.nat_instance.network_interface[0].ip_address
    external_ip = yandex_compute_instance.nat_instance.network_interface[0].nat_ip_address
  }
}

output "public_vm" {
  description = "Public VM connection details"
  value = {
    name        = yandex_compute_instance.public_vm.name
    internal_ip = yandex_compute_instance.public_vm.network_interface[0].ip_address
    external_ip = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
    ssh_command = "ssh -i ~/.ssh/id_ed25519 ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address}"
  }
}

output "private_vm" {
  description = "Private VM connection details"
  value = {
    name         = yandex_compute_instance.private_vm.name
    internal_ip  = yandex_compute_instance.private_vm.network_interface[0].ip_address
    ssh_via_jump = "ssh -i ~/.ssh/id_ed25519 -J ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address} ubuntu@${yandex_compute_instance.private_vm.network_interface[0].ip_address}"
  }
}
