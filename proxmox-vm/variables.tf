variable "ssh_key" {
  default = ""
}
variable "proxmox_host" {
  default = "UditSuperServer"
}
variable "template_name" {
  default = "ubuntu-cloud-init"
}

variable "net_config" {
  type = object({
    ip_base = string
    netmask : number
    gateway : string
  })
}

variable "vm_config" {
  type = object({
    ip_offset   = number
    node_count  = number
    name_prefix = string
    target_node = list(string)
    vmid_prefix = number
    agent       = number
    cores       = list(number)
    sockets     = list(number)
    cpu         = string
    memory      = list(number)
    scsihw      = string
    bootdisk    = string
    machine     = string
    onboot      = bool
    hostpci = optional(list(object({
      host   = string
      rombar = number
      pcie   = number
    })))
    disk = list(object({
      slot     = number
      size     = string
      type     = string
      storage  = string
      iothread = number
    }))
    network = optional(object({
      model  = string
      bridge = string
    }))
  })
}
