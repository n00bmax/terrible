locals {
  ssh_key = var.ssh_key == "" ? file("~/.ssh/id_rsa.pub") : var.ssh_key
  config  = yamldecode(file("${path.root}/config.yaml"))
}
