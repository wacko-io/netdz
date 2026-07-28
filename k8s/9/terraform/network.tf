resource "yandex_vpc_network" "k8s" {
  name        = var.vpc_name
  description = "VPC Network for Kubernetes Cluster"
}

resource "yandex_vpc_subnet" "k8s_subnets" {
  for_each       = var.subnets
  name           = "${var.vpc_name}-subnet-${each.value.zone}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.k8s.id
  v4_cidr_blocks = [each.value.cidr]
}

resource "yandex_vpc_security_group" "k8s_sg" {
  name        = "${var.vpc_name}-sg"
  description = "Security Group allowing internal Kubernetes cluster traffic and SSH access"
  network_id  = yandex_vpc_network.k8s.id

  ingress {
    protocol       = "ANY"
    description    = "Allow all internal traffic within VPC subnets"
    v4_cidr_blocks = ["10.10.0.0/16"]
  }

  ingress {
    protocol       = "TCP"
    description    = "Allow SSH from internet"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Allow all egress traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

