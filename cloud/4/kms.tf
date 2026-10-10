resource "yandex_kms_symmetric_key" "k8s_kms_key" {
  name              = "netology-k8s-kms-key"
  description       = "KMS key for Kubernetes secrets encryption"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

resource "yandex_kms_symmetric_key_iam_binding" "k8s_kms_binding" {
  symmetric_key_id = yandex_kms_symmetric_key.k8s_kms_key.id
  role             = "kms.keys.encrypterDecrypter"
  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_sa.id}",
  ]
}
