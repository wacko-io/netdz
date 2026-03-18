###cloud vars
variable "project" {
  type = string
  default = "netology"
}

variable "env" {
  type = string
  default = "develop"
  description = "VPC network & subnet name"
}

variable "vm_name" {
  description = "vm names"
  type = map(string)
  default = {
    "web" = "web"
    "db" = "db"
  }
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vm_parameters" {
  description = "parameters for vm (web and db)"
  type = map(object({
    platform_id = string
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
    family = string
    zone = string
    v4_cidr_blocks = list(string)
  }))
  default = {
    "web" = {
      platform_id = "standard-v3"
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 15
      hdd_type      = "network-hdd"
      family = "ubuntu-2004-lts"
      zone = "ru-central1-a"
      v4_cidr_blocks = ["10.0.1.0/24"]
    }
    "db" = {
      platform_id = "standard-v3"
      cores         = 2
      memory        = 4
      core_fraction = 20
      hdd_size      = 15
      hdd_type      = "network-ssd"
      family = "ubuntu-2004-lts"
      zone = "ru-central1-b"
      v4_cidr_blocks = ["10.0.2.0/24"]
    }
  }
}