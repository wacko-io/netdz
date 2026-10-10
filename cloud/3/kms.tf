resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = var.kms_key_name
  description       = "Symmetric encryption key for Object Storage bucket"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_binding" "encrypter_decrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.bucket_key.id
  role             = "kms.keys.encrypterDecrypter"
  members = [
    "serviceAccount:${var.service_account_id}",
  ]
}
