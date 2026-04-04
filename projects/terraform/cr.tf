resource "yandex_container_registry" "this" {
  name = "${var.name}-registry"
}

resource "yandex_iam_service_account" "vm_sa" {
  name        = "${var.name}-vm-sa"
  description = "Service account for VM instances"
}

resource "yandex_container_registry_iam_binding" "puller" {
  registry_id = yandex_container_registry.this.id
  role        = "container-registry.images.puller"
  members     = ["serviceAccount:${yandex_iam_service_account.vm_sa.id}"]
}