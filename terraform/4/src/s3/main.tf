# To always have a unique bucket name in this example
resource "random_string" "unique_id" {
  length  = 8
  upper   = false
  lower   = true
  numeric = true
  special = false
}

module "s3" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git?ref=1.0.4"
  bucket_name = "simple-bucket-${random_string.unique_id.result}"
  max_size = 1 * 1024 * 1024 * 1024 # 1 GB
  versioning = {
    enabled = false
  }
}