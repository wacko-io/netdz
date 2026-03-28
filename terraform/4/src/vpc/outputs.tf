output "vpc_subnet_ids"{
    value = [for s in yandex_vpc_subnet.subnet : s.id]
}
output "vpc_zone"{
    value = [for s in yandex_vpc_subnet.subnet : s.zone]
}
output "vpc_network_id"{
    value = yandex_vpc_network.network.id    
}
output "vpc_cidr"{
    value = [for s in yandex_vpc_subnet.subnet : s.v4_cidr_blocks]
}