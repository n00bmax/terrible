resource "proxmox_vm_qemu" "kube-node" {
  count       = var.vm_config.node_count
  name        = "${var.vm_config.name_prefix}${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "${var.vm_config.vmid_prefix}${count.index + 1}"

  clone    = var.template_name
  agent    = 1
  os_type  = "cloud-init"
  cores    = var.vm_config.cores
  sockets  = var.vm_config.sockets
  cpu      = var.vm_config.cpu
  memory   = var.vm_config.memory
  scsihw   = var.vm_config.scsihw
  bootdisk = var.vm_config.bootdisk

  disk {
    slot     = var.vm_config.disk.slot
    size     = var.vm_config.disk.size
    type     = var.vm_config.disk.type
    storage  = var.vm_config.disk.storage
    iothread = var.vm_config.disk.iothread
  }

  network {
    model  = var.vm_config.network.model
    bridge = var.vm_config.network.bridge
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  #   ipconfig0 = "ip=10.10.5.7${count.index + 1}/12,gw=10.0.0.1"
  ipconfig0 = "ip=${trimsuffix(local.config.net_config.ip_base, "0")}${var.vm_config.ip_offset + count.index + 1}/${local.config.net_config.netmask},gw=${local.config.net_config.gateway}"

  sshkeys = <<EOF
  ${local.ssh_key}
  EOF
}

