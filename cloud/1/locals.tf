locals {
  common_metadata = {
    serial-port-enable = "1"
    ssh-keys           = "ubuntu:${file(pathexpand(var.ssh_public_key_path))}"
  }
}
