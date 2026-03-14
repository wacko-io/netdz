provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_vpc_network" "netology" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "netology" {
  name           = var.subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.netology.id
  v4_cidr_blocks = var.subnet_cidr_blocks
}

resource "yandex_vpc_security_group" "netology" {
  name       = var.security_group_name
  network_id = yandex_vpc_network.netology.id

  ingress {
    description    = "SSH"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  ingress {
    description    = "Docker Swarm manager"
    protocol       = "TCP"
    port           = 2377
    v4_cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description    = "Docker Swarm node communication TCP"
    protocol       = "TCP"
    port           = 7946
    v4_cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description    = "Docker Swarm node communication UDP"
    protocol       = "UDP"
    port           = 7946
    v4_cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description    = "Docker Swarm overlay network"
    protocol       = "UDP"
    port           = 4789
    v4_cidr_blocks = var.subnet_cidr_blocks
  }

  ingress {
    description    = "Application public port"
    protocol       = "TCP"
    port           = var.app_public_port
    v4_cidr_blocks = var.allowed_app_cidr_blocks
  }

  egress {
    description    = "Allow all outgoing traffic"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_instance" "nodes" {
  for_each = toset(var.instance_names)

  name        = each.value
  hostname    = each.value
  zone        = var.zone
  platform_id = var.platform_id
  allow_stopping_for_update = true

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.boot_disk_size
      type     = var.boot_disk_type
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.netology.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.netology.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
      vm_user        = var.vm_user
      ssh_public_key = trimspace(file(var.ssh_public_key_path))
    })
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id,
    ]
  }
}
