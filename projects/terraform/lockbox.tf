resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "yandex_lockbox_secret" "mysql_password" {
  name = "${var.name}-mysql-password"
}

resource "yandex_lockbox_secret_version" "v1" {
  secret_id = yandex_lockbox_secret.mysql_password.id
  entries {
    key        = "db_password"
    text_value = random_password.mysql_password.result
  }
}