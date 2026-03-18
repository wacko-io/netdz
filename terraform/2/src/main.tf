resource "yandex_vpc_network" "develop" {
  name = var.env
}
resource "yandex_vpc_subnet" "develop" {
  name           = "${var.env}-${var.vm_name["web"]}"
  zone           = var.vm_parameters["web"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_parameters["web"].v4_cidr_blocks
}

resource "yandex_vpc_subnet" "develop_db" {
  name           = "${var.env}-${var.vm_name["db"]}"
  zone           = var.vm_parameters["db"].zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_parameters["db"].v4_cidr_blocks
}

data "yandex_compute_image" "ubuntu-web" {
  family = var.vm_parameters["web"].family
}

data "yandex_compute_image" "ubuntu-db" {
  family = var.vm_parameters["db"].family
}

resource "yandex_compute_instance" "platform" {
  name        = local.platform
  platform_id = var.vm_parameters["web"].platform_id
  zone        = var.vm_parameters["web"].zone
  resources {
    cores         = var.vm_parameters["web"].cores
    memory        = var.vm_parameters["web"].memory
    core_fraction = var.vm_parameters["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-web.id
      size = var.vm_parameters["web"].hdd_size
      type = var.vm_parameters["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = local.common_metadata
}

resource "yandex_compute_instance" "platform_db" {
  name = local.platform_db
  platform_id = var.vm_parameters["db"].platform_id
  zone        = var.vm_parameters["db"].zone
  resources {
    cores         = var.vm_parameters["db"].cores
    memory        = var.vm_parameters["db"].memory
    core_fraction = var.vm_parameters["db"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-db.id
      size = var.vm_parameters["db"].hdd_size
      type = var.vm_parameters["db"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_db.id
    nat       = false
  }
  metadata = local.common_metadata
}
