resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name        = var.k8s_cluster_name
  network_id  = yandex_vpc_network.vpc.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.public_a.zone
        subnet_id = yandex_vpc_subnet.public_a.id
      }
      location {
        zone      = yandex_vpc_subnet.public_d.zone
        subnet_id = yandex_vpc_subnet.public_d.id
      }
      location {
        zone      = yandex_vpc_subnet.public_e.zone
        subnet_id = yandex_vpc_subnet.public_e.id
      }
    }

    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.k8s_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_kms_key.id
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_clusters_agent,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.images_puller,
    yandex_resourcemanager_folder_iam_member.load_balancer_admin,
    yandex_kms_symmetric_key_iam_binding.k8s_kms_binding
  ]
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "netology-k8s-node-group"

  instance_template {
    platform_id = "standard-v2"

    resources {
      core_fraction = 20
      cores         = 2
      memory        = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = false
    }

    network_interface {
      nat        = true
      subnet_ids = [
        yandex_vpc_subnet.public_a.id
      ]
    }
  }

  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = yandex_vpc_subnet.public_a.zone
    }
  }
}
