terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.196.0"
    }
  }
  required_version = "~>1.14.0"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket = "terraform-project-state"
    key    = "terraform.tfstate"
    region = "ru-central1"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/yc_terraform_authorized_key.json")
}