resource "yandex_vpc_network" "this" {
  name = "${var.name}-vpc"
}

resource "yandex_vpc_subnet" "public" {
  name           = "terraform-project-public-${var.default_zone}"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "ubuntu-web" {
  family = var.vm_parameters["web"].family
}

resource "yandex_compute_instance" "web" {
  name               = "${var.name}-web"
  platform_id        = var.vm_parameters["web"].platform_id
  zone               = var.default_zone
  service_account_id = yandex_iam_service_account.vm_sa.id

  resources {
    cores         = var.vm_parameters["web"].cores
    memory        = var.vm_parameters["web"].memory
    core_fraction = var.vm_parameters["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-web.id
      size     = var.vm_parameters["web"].hdd_size
      type     = var.vm_parameters["web"].hdd_type
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      ssh_key = file(pathexpand("~/.ssh/terraform-project.pub"))
    })
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id
    ]
  }
}

resource "yandex_mdb_mysql_cluster" "this" {
  name        = "${var.name}-mysql-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.this.id
  version     = "8.0"

  resources {
    resource_preset_id = var.mysql_parameters.resource_preset_id
    disk_size          = var.mysql_parameters.disk_size
    disk_type_id       = var.mysql_parameters.disk_type_id
  }

  host {
    zone      = var.default_zone
    subnet_id = yandex_vpc_subnet.public.id
  }
}

resource "yandex_mdb_mysql_database" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "${var.name}-mysql-db"
}

resource "yandex_mdb_mysql_user" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "${var.name}-admin"
  password   = yandex_lockbox_secret_version.v1.entries[0].text_value
  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }
}