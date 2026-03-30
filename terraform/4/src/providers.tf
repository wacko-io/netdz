terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6"
    }
    template = {
      source = "hashicorp/template"
      version = "~> 2.2"
    }
  }
  backend "s3" {
    bucket  = "simple-bucket-qiavqa5j"
    key     = "terraform.tfstate"
    region  = "ru-central1"

    # Встроенный механизм блокировок (Terraform >= 1.6)
    # Не требует отдельной базы данных!
    use_lockfile = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  required_version = ">=1.12.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
  service_account_key_file = file("~/.ssh/yc_terraform_authorized_key.json")
}

