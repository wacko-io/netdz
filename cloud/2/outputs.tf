output "bucket_name" {
  value = yandex_storage_bucket.lamp_bucket.bucket
}

output "picture_url" {
  value = local.image_url
}

output "load_balancer_public_ip" {
  value = tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address
}

output "load_balancer_url" {
  value = "http://${tolist(tolist(yandex_lb_network_load_balancer.lb.listener)[0].external_address_spec)[0].address}"
}

output "instance_group_instances" {
  value = [
    for instance in yandex_compute_instance_group.lamp_group.instances : {
      name        = instance.name
      instance_id = instance.instance_id
      status      = instance.status
      internal_ip = instance.network_interface[0].ip_address
      external_ip = instance.network_interface[0].nat_ip_address
    }
  ]
}
