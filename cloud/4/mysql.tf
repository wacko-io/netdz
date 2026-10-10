resource "yandex_mdb_mysql_cluster" "mysql" {
  name        = var.mysql_cluster_name
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.vpc.id
  version     = "8.0"

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  deletion_protection = true

  host {
    zone      = yandex_vpc_subnet.private_a.zone
    subnet_id = yandex_vpc_subnet.private_a.id
  }

  host {
    zone      = yandex_vpc_subnet.private_d.zone
    subnet_id = yandex_vpc_subnet.private_d.id
  }
}

resource "yandex_mdb_mysql_database" "db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "user" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = var.db_user
  password   = var.db_password
  permission {
    database_name = yandex_mdb_mysql_database.db.name
    roles         = ["ALL"]
  }
}
