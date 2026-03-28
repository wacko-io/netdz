terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">=1.12.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  service_account_key_file = file("~/.ssh/yc_terraform_authorized_key.json")
  storage_access_key = var.YC_STORAGE_ACCESS_KEY
  storage_secret_key = var.YC_STORAGE_SECRET_KEY
}