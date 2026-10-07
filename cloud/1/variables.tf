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

variable "service_account_key_file" {
  type        = string
  default     = "~/.ssh/yc_terraform_authorized_key.json"
  description = "Path to service account key file"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
  description = "Path to SSH public key"
}

variable "vpc_name" {
  type        = string
  default     = "netology-vpc"
  description = "VPC network name"
}

variable "public_subnet_name" {
  type        = string
  default     = "public"
  description = "Name for public subnet"
}

variable "public_cidr" {
  type        = string
  default     = "192.168.10.0/24"
  description = "CIDR block for public subnet"
}

variable "private_subnet_name" {
  type        = string
  default     = "private"
  description = "Name for private subnet"
}

variable "private_cidr" {
  type        = string
  default     = "192.168.20.0/24"
  description = "CIDR block for private subnet"
}

variable "nat_ip" {
  type        = string
  default     = "192.168.10.254"
  description = "Static internal IP for NAT instance"
}

variable "nat_image_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Marketplace Image ID for NAT instance"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2204-lts"
  description = "Image family for public and private compute instances"
}

variable "vm_resources" {
  description = "Resource specification for VMs"
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
    hdd_size      = 15
    hdd_type      = "network-hdd"
  }
}
