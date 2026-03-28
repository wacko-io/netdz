variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "YC_STORAGE_ACCESS_KEY" {
  description = "Access key for S3"
  type        = string
  sensitive   = true
}

variable "YC_STORAGE_SECRET_KEY" {
  description = "Secret key for S3"
  type        = string
  sensitive   = true
}