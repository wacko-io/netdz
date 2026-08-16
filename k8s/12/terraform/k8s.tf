resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name       = "k8s-managed-cluster"
  network_id = yandex_vpc_network.k8s_network.id

  master {
    version = var.k8s_version
    zonal {
      zone      = var.default_zone
      subnet_id = yandex_vpc_subnet.k8s_subnet.id
    }
    public_ip          = true
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
  }

  service_account_id      = yandex_iam_service_account.k8s_master_sa.id
  node_service_account_id = yandex_iam_service_account.k8s_nodes_sa.id

  network_policy_provider = "CALICO"
  release_channel         = "STABLE"

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_master_agent,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.lb_admin,
    yandex_resourcemanager_folder_iam_member.images_puller
  ]
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "k8s-workers"
  version    = var.k8s_version

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = [yandex_vpc_subnet.k8s_subnet.id]
      security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
    }

    resources {
      memory        = 4
      cores         = 2
      core_fraction = 100
    }

    boot_disk {
      type = "network-ssd"
      size = 40
    }

    metadata = {
      ssh-keys = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.default_zone
    }
  }
}
