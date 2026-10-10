resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public_a" {
  name           = "public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "public_d" {
  name           = "public-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.10.2.0/24"]
}

resource "yandex_vpc_subnet" "public_e" {
  name           = "public-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.10.3.0/24"]
}

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.20.1.0/24"]
}

resource "yandex_vpc_subnet" "private_d" {
  name           = "private-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.20.2.0/24"]
}

resource "yandex_vpc_subnet" "private_e" {
  name           = "private-e"
  zone           = "ru-central1-e"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.20.3.0/24"]
}
