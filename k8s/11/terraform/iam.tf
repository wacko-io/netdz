resource "yandex_iam_service_account" "k8s_master_sa" {
  name = "k8s-master-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_master_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_master_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_public_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_master_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "lb_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_master_sa.id}"
}

resource "yandex_iam_service_account" "k8s_nodes_sa" {
  name = "k8s-nodes-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "images_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes_sa.id}"
}
