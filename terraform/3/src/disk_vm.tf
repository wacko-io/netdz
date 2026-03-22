resource "yandex_compute_disk" "vdisk" {
  count = 3
  name  = "netology-${var.vpc_name}-disk-${count.index + 1}"
  zone  = var.default_zone
  type  = var.disk_resources.type
  size  = var.disk_resources.size
}

data yandex_compute_image "ubuntu-storage" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "storage" {
  name        = "netology-${var.vpc_name}-storage"
  platform_id = var.storage_resources.platform_id
  zone        = var.default_zone
  resources {
    cores         = var.storage_resources.cores
    memory        = var.storage_resources.memory
    core_fraction = var.storage_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-storage.id
      size     = var.storage_resources.size
      type     = var.storage_resources.type
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.vdisk
    content {
      disk_id = secondary_disk.value.id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
  }
  
}