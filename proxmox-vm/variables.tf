variable "ssh_key" {
  default = ""
}
variable "proxmox_host" {
  default = "UditSuperServer"
}
variable "template_name" {
  default = "ubuntu-cloud-init"
}

variable "vm_config" {
  type = object({
    ip_offset   = number
    node_count  = number
    name_prefix = string
    target_node = string
    vmid_prefix = number
    agent       = number
    cores       = number
    sockets     = number
    cpu         = string
    memory      = number
    scsihw      = string
    bootdisk    = string
    disk = object({
      slot     = number
      size     = string
      type     = string
      storage  = string
      iothread = number
    })
    network = object({
      model  = string
      bridge = string
    })
  })
}
