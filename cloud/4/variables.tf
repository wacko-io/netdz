variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
}

variable "service_account_id" {
  type        = string
  description = "Service account ID"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Default availability zone"
}

variable "service_account_key_file" {
  type        = string
  default     = "~/.ssh/yc_terraform_authorized_key.json"
  description = "Path to service account key file"
}

variable "vpc_name" {
  type        = string
  default     = "netology-vpc-4"
  description = "VPC network name"
}

variable "mysql_cluster_name" {
  type        = string
  default     = "netology-mysql"
  description = "Name for MySQL cluster"
}

variable "mysql_resource_preset" {
  type        = string
  default     = "b1.medium"
  description = "Resource preset for MySQL cluster (Intel Broadwell 50% CPU)"
}

variable "db_name" {
  type        = string
  default     = "netology_db"
  description = "MySQL database name"
}

variable "db_user" {
  type        = string
  default     = "netology_user"
  description = "MySQL database user name"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "MySQL database user password"
}

variable "k8s_cluster_name" {
  type        = string
  default     = "netology-k8s-cluster"
  description = "Name for Managed Kubernetes cluster"
}
