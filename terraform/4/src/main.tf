resource "random_password" "db_password" {
  length  = 16
  special = true
}


data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yml")
  vars = {
    ssh_root_key = var.vms_ssh_root_key
  }
}

module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" }
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" }
  ]
}

locals{
    is_ha = true
}

# module "example_cluster" {
#   source       = "./mysql"
#   cluster_name  = "example-mysql-cluster"
#   network_id    = local.is_ha ? module.vpc_prod.vpc_network_id : module.vpc_dev.vpc_network_id
#   HA            = local.is_ha
#   subnets = local.is_ha ? [
#     { zone = "ru-central1-a", subnet_id = module.vpc_prod.vpc_subnet_ids[0] },
#     { zone = "ru-central1-b", subnet_id = module.vpc_prod.vpc_subnet_ids[1] }
#   ] : [
#     { zone = "ru-central1-a", subnet_id = module.vpc_dev.vpc_subnet_ids[0] }
#   ]
#   cluster_resources = {
#     resource_preset_id = "s2.micro",
#     disk_type_id = "network-ssd",
#     disk_size = local.is_ha ? 20 : 10
#   }
# }

# module "example_db" {
#   source = "./mysql_db"
#   cluster_id = module.example_cluster.cluster_id
#   db_name =  "test"
#   db_user = "app"
#   db_password = random_password.db_password.result
# }

module "m-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc_dev.vpc_network_id
  subnet_zones   = module.vpc_dev.vpc_zone
  subnet_ids     = module.vpc_dev.vpc_subnet_ids
  instance_name  = "marketing"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner= "i.ivanov",
    project = "marketing"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }

}

module "a-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "production"
  network_id     = module.vpc_prod.vpc_network_id
  subnet_zones   = module.vpc_prod.vpc_zone
  subnet_ids     = module.vpc_prod.vpc_subnet_ids
  instance_name  = "analytics"  
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true

  labels = { 
    owner= "p.petrov",
    project = "analytics"
     }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

