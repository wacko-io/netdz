resource "yandex_vpc_network" "network" {
  name = var.env_name
}
resource "yandex_vpc_subnet" "subnet" {
  for_each = {for s in var.subnets : s.zone => s}
  name           = "${var.env_name}-${each.value.zone}"
  zone = each.value.zone
  v4_cidr_blocks = [each.value.cidr]
  network_id     = yandex_vpc_network.network.id
}