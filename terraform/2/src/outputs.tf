output "vms_info" {
    description = "instance_name, external_ip, fqdn of web and db servers"
    value = {
        web = {
            instance_name = yandex_compute_instance.platform.name
            external_ip = yandex_compute_instance.platform.network_interface.0.nat_ip_address
            fqdn = yandex_compute_instance.platform.fqdn
        }
        db = {
            instance_name = yandex_compute_instance.platform_db.name
            external_ip = yandex_compute_instance.platform_db.network_interface.0.nat_ip_address
            fqdn = yandex_compute_instance.platform_db.fqdn
        }
    }
}