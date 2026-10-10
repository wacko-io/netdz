output "kms_key_id" {
  value       = yandex_kms_symmetric_key.bucket_key.id
  description = "ID of KMS symmetric key"
}

output "kms_key_name" {
  value       = yandex_kms_symmetric_key.bucket_key.name
  description = "Name of KMS symmetric key"
}

output "bucket_name" {
  value       = yandex_storage_bucket.encrypted_bucket.bucket
  description = "Name of encrypted Object Storage bucket"
}

output "picture_url" {
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.encrypted_bucket.bucket}/picture.png"
  description = "Direct URL to picture.png in Object Storage"
}
