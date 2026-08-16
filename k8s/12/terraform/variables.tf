variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "service_account_key_file" {
  type    = string
  default = "~/.ssh/yc_terraform_authorized_key.json"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/yc_ansible.pub"
}

variable "k8s_version" {
  type    = string
  default = "1.34"
}
