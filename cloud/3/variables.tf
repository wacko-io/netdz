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

variable "bucket_prefix" {
  type        = string
  default     = "netology-encrypted-bucket"
  description = "Prefix for S3 bucket name"
}

variable "kms_key_name" {
  type        = string
  default     = "netology-bucket-kms-key"
  description = "Name for KMS symmetric key"
}
