variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "service_account_key_file" {
  type        = string
  description = "Path to Yandex Cloud Service Account Key JSON file"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default availability zone"
}

variable "zones" {
  type        = list(string)
  default     = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
  description = "List of availability zones for multi-zone distribution"
}

variable "subnets" {
  type = map(object({
    zone = string
    cidr = string
  }))
  default = {
    "ru-central1-a" = { zone = "ru-central1-a", cidr = "10.10.1.0/24" }
    "ru-central1-b" = { zone = "ru-central1-b", cidr = "10.10.2.0/24" }
    "ru-central1-d" = { zone = "ru-central1-d", cidr = "10.10.3.0/24" }
  }
  description = "Subnet CIDR configuration for each availability zone"
}

variable "vpc_name" {
  type        = string
  default     = "k8s-network"
  description = "VPC network name"
}

variable "master_count" {
  type        = number
  default     = 1
  description = "Number of master nodes"
}

variable "worker_count" {
  type        = number
  default     = 4
  description = "Number of worker nodes"
}

variable "master_resources" {
  type = object({
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    platform_id   = "standard-v3"
    cores         = 2
    memory        = 4
    core_fraction = 20
    disk_size     = 20
    disk_type     = "network-hdd"
  }
  description = "Resource specifications for master nodes"
}

variable "worker_resources" {
  type = object({
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    disk_size     = number
    disk_type     = string
  })
  default = {
    platform_id   = "standard-v3"
    cores         = 2
    memory        = 4
    core_fraction = 20
    disk_size     = 20
    disk_type     = "network-hdd"
  }
  description = "Resource specifications for worker nodes"
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
  description = "OS Image family"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key for node authorization"
}
