resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = var.folder_id
  service_account_id = var.service_account_id

  instance_template {
    platform_id = var.vm_resources.platform_id

    resources {
      cores         = var.vm_resources.cores
      memory        = var.vm_resources.memory
      core_fraction = var.vm_resources.core_fraction
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = var.vm_resources.hdd_size
        type     = var.vm_resources.hdd_type
      }
    }

    network_interface {
      network_id = yandex_vpc_network.vpc.id
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      user-data = templatefile("${path.module}/cloud-init.yaml", {
        ssh_key   = file(pathexpand(var.ssh_public_key_path))
        image_url = local.image_url
      })
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    fixed_scale {
      size = var.instance_count
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval            = 2
    timeout             = 1
    healthy_threshold   = 2
    unhealthy_threshold = 2
    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name        = "lamp-target-group"
    target_group_description = "Target group for LAMP instance group"
  }

  depends_on = [
    yandex_storage_object.picture
  ]
}
