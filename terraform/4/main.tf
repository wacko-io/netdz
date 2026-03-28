provider "vault" {
 address = "http://127.0.0.1:8200"
 skip_tls_verify = true
 token = "education"
}
data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

resource random_password "password" {
  length  = 16
  special = true
}

resource "vault_kv_secret_v2" "db_creds" {
  mount = "secret"

  name = "secret/db"

  data_json = jsonencode({
    username = "admin"
    password = random_password.password.result
    port = 3306
  })
  
}

output "vault_example" {
 value = "${nonsensitive(data.vault_generic_secret.vault_example.data)}"
} 