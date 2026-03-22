###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vm_resources" {
  description = "resources for vm (web)"
  type = object({
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    hdd_size      = number
    hdd_type      = string
  })
  default = {
    platform_id   = "standard-v3"
    cores         = 2
    memory        = 2
    core_fraction = 20
    hdd_size      = 10
    hdd_type      = "network-hdd"
  }
}

variable "each_db" {
  type = map(object({
    vm_name       = string
    cores         = number
    memory        = number
    hdd_size      = number
    hdd_type      = string
    platform_id   = string
    core_fraction = number
  }))
  default = {
    main = {
      vm_name       = "main"
      platform_id   = "standard-v3"
      cores         = 2
      core_fraction = 20
      memory        = 4
      hdd_size      = 15
      hdd_type      = "network-hdd"
    },
    replica = {
      vm_name       = "replica"
      platform_id   = "standard-v3"
      cores         = 2
      core_fraction = 20
      memory        = 2
      hdd_size      = 10
      hdd_type      = "network-hdd"
    }
  }
}

variable "disk_resources" {
  description = "resources for disks"
  type = object({
    size = number
    type = string
  })
  default = {
    size = 1
    type = "network-hdd"
  }
}

variable "storage_resources" {
  description = "resources for vm (storage)"
  type = object({
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    size = number
    type = string
  })
  default = {
    platform_id   = "standard-v3"
    cores         = 2
    memory        = 4
    core_fraction = 20
    size = 10
    type = "network-hdd"
  }
}