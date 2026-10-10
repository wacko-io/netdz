resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = var.service_account_id
  description        = "Static access key for Object Storage"
}

resource "random_string" "bucket_name" {
  length  = 8
  special = false
  upper   = false
}

resource "yandex_storage_bucket" "encrypted_bucket" {
  depends_on = [yandex_kms_symmetric_key_iam_binding.encrypter_decrypter]

  access_key    = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key    = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  bucket        = "${var.bucket_prefix}-${random_string.bucket_name.result}"
  max_size      = 1073741824
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}

resource "yandex_storage_object" "picture" {
  access_key  = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key  = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  bucket      = yandex_storage_bucket.encrypted_bucket.bucket
  key         = "picture.png"
  source      = "${path.module}/picture.png"
  source_hash = filemd5("${path.module}/picture.png")
  acl         = "public-read"
}
