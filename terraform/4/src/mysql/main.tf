resource "yandex_mdb_mysql_cluster" "cluster" {
    name = var.cluster_name
    network_id = var.network_id
    environment = var.HA ? "PRODUCTION" : "PRESTABLE"
    version = "8.0"
    
    resources {
        resource_preset_id = var.cluster_resources.resource_preset_id
        disk_size = var.cluster_resources.disk_size
        disk_type_id = var.cluster_resources.disk_type_id
    }

    dynamic "host" {
        for_each = local.hosts_to_create
        content {
            zone = host.value.zone
            subnet_id = host.value.subnet_id
        }
    }
}