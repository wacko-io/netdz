resource "yandex_mdb_mysql_database" "database" {
    cluster_id = var.cluster_id
    name = var.db_name
}

resource "yandex_mdb_mysql_user" "user" {
    cluster_id = var.cluster_id
    name = var.db_user
    password = var.db_password

    permission {
        database_name = yandex_mdb_mysql_database.database.name
        roles = ["ALL"]
    }
}