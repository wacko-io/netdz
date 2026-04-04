output "web_public_ip_address" {
  value = yandex_compute_instance.web.network_interface[0].nat_ip_address
}

output "registry_id" {
  value = yandex_container_registry.this.id
}

output "db_mysql_host" {
  value = yandex_mdb_mysql_cluster.this.host[0].fqdn
}