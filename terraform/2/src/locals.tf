locals{
  platform = "${var.project}-${var.env}-${var.vm_name["web"]}"
  platform_db = "${var.project}-${var.env}-${var.vm_name["db"]}"
  common_metadata = {
    serial-port-enable = "1"
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}