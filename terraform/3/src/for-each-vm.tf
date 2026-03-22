data "yandex_compute_image" "ubuntu-db" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "db" {
  for_each = var.each_db

  name     = "netology-${var.vpc_name}-${each.key}"
  hostname = "netology-${var.vpc_name}-${each.key}"

  platform_id = each.value.platform_id

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-db.id
      size     = each.value.hdd_size
      type     = each.value.hdd_type
    }
  }

  scheduling_policy {
    preemptible = false
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
}