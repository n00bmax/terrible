variable "ssh_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCaZ1poecjTQp5GkWjJVCYgiJaQlOCldZGNxX1VsyphyHjvDPennijfqAY8CCEBxWL7s/xV2G/8ZswmP+m/SxoV84wSv1Ni6sXp02ZI7cF1lBZDvypQVIlQy6uCrY218/IwWMYBDA8ciZ15nep9vqIUMeBK84A5Wydu2UcUhAbhM3mi8QxzOvX2HFOpxi7zXDrjKr5Lx4L2JfP/lr9oJVTQ5slCV6Cl5q4At6U+MShFgz43dWpt9g23IUtSXZzxOaUAOZG4ChOEMkRydtDC6R6aPdnCxz9TAVEW8cG3YcQokvR6nWxg8RcYLCdLyMnC4PtD1GiYjtbeZy4A+kg+IOuP root@MainServer"
}
variable "proxmox_host" {
  default = "UditSuperServer"
}
variable "template_name" {
  default = "ubuntu-cloud-init"
}

variable "cluster_config" {
  type = object({
    worker = object({
      node_count = number
      ip_offset  = number

    })
    gpu = object({
      node_count = number
      ip_offset  = number

    })
    control_plane = object({
      node_count = number
      ip_offset  = number

    })
    ip_base = string
    netmask = number
    gateway = string

  })
  default = ({
    worker = {
      node_count = 2
      ip_offset  = 50
    }
    gpu = {
      node_count = 1
      ip_offset  = 80
    }
    control_plane = {
      node_count = 2
      ip_offset  = 70
    }
    ip_base = "10.10.5.0"
    netmask = 12
    gateway = "10.0.0.1"
  })
}
