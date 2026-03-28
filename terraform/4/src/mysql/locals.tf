locals {
    actual_host_count = var.HA ? var.ha_hosts_count : 1
    hosts_to_create = slice(var.subnets, 0, local.actual_host_count)
}