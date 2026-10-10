locals {
  image_url = "https://storage.yandexcloud.net/${yandex_storage_bucket.lamp_bucket.bucket}/${yandex_storage_object.picture.key}"
}
