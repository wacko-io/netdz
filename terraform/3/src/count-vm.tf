data "yandex_compute_image" "ubuntu-web" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]
  count      = 2

  platform_id = var.vm_resources.platform_id
  name        = "netology-${var.vpc_name}-web-${count.index + 1}"
  hostname    = "netology-${var.vpc_name}-web-${count.index + 1}"
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-web.id
      size     = var.vm_resources.hdd_size
      type     = var.vm_resources.hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
}