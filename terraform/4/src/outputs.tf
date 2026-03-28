output "marketing_vm_public_ips" {
    value = module.m-vm.network_interface[0][0].nat_ip_address
}

output "analytics_vm_public_ips" {
    value = module.a-vm.network_interface[0][0].nat_ip_address
}