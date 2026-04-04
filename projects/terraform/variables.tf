variable "cloud_id" {
  description = "ID of the Yandex.Cloud cloud"
  type        = string
}

variable "folder_id" {
  description = "ID of the Yandex.Cloud folder"
  type        = string
}

variable "default_zone" {
  description = "Default zone for Yandex.Cloud resources"
  type        = string
  default     = "ru-central1-a"
}

variable "default_cidr" {
  description = "Default CIDR block for the VPC subnet"
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "name" {
  description = "Base name for resources"
  type        = string
  default     = "terraform-project"
}

variable "vm_parameters" {
  description = "Parameters for VM instances"
  type = map(object({
    platform_id    = string
    zone           = string
    cores          = number
    memory         = number
    core_fraction  = number
    hdd_size       = number
    hdd_type       = string
    family         = string
    v4_cidr_blocks = list(string)
  }))
  default = {
    web = {
      platform_id    = "standard-v1"
      zone           = "ru-central1-a"
      cores          = 2
      memory         = 4
      core_fraction  = 20
      hdd_size       = 10
      hdd_type       = "network-hdd"
      family         = "ubuntu-2404-lts-oslogin"
      v4_cidr_blocks = ["10.0.1.0/24"]
    }
  }
}

variable "mysql_parameters" {
  description = "Parameters for MySQL cluster"
  type = object({
    resource_preset_id = string
    disk_size          = number
    disk_type_id       = string
  })
  default = {
    resource_preset_id = "b1.medium"
    disk_size          = 10
    disk_type_id       = "network-ssd"
  }
}