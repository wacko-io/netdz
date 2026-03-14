variable "yc_token" {
  description = "Yandex Cloud IAM token"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "netology-network"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
  default     = "netology-subnet-a"
}

variable "subnet_cidr_blocks" {
  description = "Subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.10.0/24"]
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
  default     = "netology-ssh-sg"
}

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed to connect over SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_app_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the published application port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_public_port" {
  description = "Published TCP port for the application exposed from Docker Swarm"
  type        = number
  default     = 8080
}

variable "instance_names" {
  description = "Virtual machine names"
  type        = list(string)
  default     = ["node-1", "node-2", "node-3"]
}

variable "platform_id" {
  description = "Yandex Compute platform ID"
  type        = string
  default     = "standard-v3"
}

variable "cores" {
  description = "Number of vCPUs per VM"
  type        = number
  default     = 2
}

variable "memory" {
  description = "RAM amount in GB per VM"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Guaranteed vCPU fraction"
  type        = number
  default     = 20
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "network-hdd"
}

variable "image_family" {
  description = "Public image family used for the VM boot disk"
  type        = string
  default     = "ubuntu-2204-lts"
}

variable "preemptible" {
  description = "Whether VMs should be preemptible"
  type        = bool
  default     = true
}

variable "vm_user" {
  description = "Linux user created via cloud-init for SSH and Ansible"
  type        = string
  default     = "netology"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key that will be injected into VM metadata"
  type        = string
}
