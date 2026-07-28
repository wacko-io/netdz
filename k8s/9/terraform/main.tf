data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_compute_instance" "k8s_master" {
  count       = var.master_count
  name        = "k8s-master-${count.index + 1}"
  hostname    = "k8s-master-${count.index + 1}"
  platform_id = var.master_resources.platform_id
  zone        = var.zones[count.index % length(var.zones)]

  resources {
    cores         = var.master_resources.cores
    memory        = var.master_resources.memory
    core_fraction = var.master_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.master_resources.disk_size
      type     = var.master_resources.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s_subnets[var.zones[count.index % length(var.zones)]].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
    user-data = <<-EOF
      #cloud-config
      hostname: k8s-master-${count.index + 1}
      write_files:
        - path: /etc/sysctl.d/k8s.conf
          content: |
            net.ipv4.ip_forward = 1
            net.bridge.bridge-nf-call-iptables = 1
            net.bridge.bridge-nf-call-ip6tables = 1
      runcmd:
        - modprobe overlay
        - modprobe br_netfilter
        - sysctl --system
    EOF
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id
    ]
  }
}

resource "yandex_compute_instance" "k8s_worker" {
  count       = var.worker_count
  name        = "k8s-worker-${count.index + 1}"
  hostname    = "k8s-worker-${count.index + 1}"
  platform_id = var.worker_resources.platform_id
  zone        = var.zones[count.index % length(var.zones)]

  resources {
    cores         = var.worker_resources.cores
    memory        = var.worker_resources.memory
    core_fraction = var.worker_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.worker_resources.disk_size
      type     = var.worker_resources.disk_type
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.k8s_subnets[var.zones[count.index % length(var.zones)]].id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.k8s_sg.id]
  }

  metadata = {
    ssh-keys  = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
    user-data = <<-EOF
      #cloud-config
      hostname: k8s-worker-${count.index + 1}
      write_files:
        - path: /etc/sysctl.d/k8s.conf
          content: |
            net.ipv4.ip_forward = 1
            net.bridge.bridge-nf-call-iptables = 1
            net.bridge.bridge-nf-call-ip6tables = 1
      runcmd:
        - modprobe overlay
        - modprobe br_netfilter
        - sysctl --system
    EOF
  }

  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image_id
    ]
  }
}
