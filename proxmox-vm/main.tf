resource "proxmox_vm_qemu" "kube-node" {
  count       = var.vm_config.node_count
  name        = "${var.vm_config.name_prefix}${count.index + 1}"
  target_node = element(var.vm_config.target_node, "${count.index}")
  vmid        = "${var.vm_config.vmid_prefix}${count.index + 1}"
  clone       = var.template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = element(var.vm_config.cores, "${count.index}")
  sockets     = element(var.vm_config.sockets, "${count.index}")
  cpu         = var.vm_config.cpu
  memory      = element(var.vm_config.memory, "${count.index}")
  scsihw      = var.vm_config.scsihw
  bootdisk    = var.vm_config.bootdisk

  disk {
    slot     = element(var.vm_config.disk, "${count.index}").slot
    size     = element(var.vm_config.disk, "${count.index}").size
    type     = element(var.vm_config.disk, "${count.index}").type
    storage  = element(var.vm_config.disk, "${count.index}").storage
    iothread = element(var.vm_config.disk, "${count.index}").iothread
  }

  network {
    model  = var.vm_config.network == null ? null : var.vm_config.network.model
    bridge = var.vm_config.network == null ? null : var.vm_config.network.bridge
  }
  lifecycle {
    # precondition {
    #   condition     = var.vm_config.node_count == length(var.vm_config.hostpci)
    #   error_message = "errrr"
    # }
    ignore_changes = [
      network,
    ]
  }

  machine = var.vm_config.machine

  hostpci {
    host   = length(var.vm_config.hostpci) <= "${count.index}" ? null : var.vm_config.hostpci["${count.index}"].host
    rombar = length(var.vm_config.hostpci) <= "${count.index}" ? null : var.vm_config.hostpci["${count.index}"].rombar
    pcie   = length(var.vm_config.hostpci) <= "${count.index}" ? null : var.vm_config.hostpci["${count.index}"].pcie
  }

  #   ipconfig0 = "ip=10.10.5.7${count.index + 1}/12,gw=10.0.0.1"
  ipconfig0 = "ip=${trimsuffix(var.net_config.ip_base, "0")}${var.vm_config.ip_offset + count.index + 1}/${var.net_config.netmask},gw=${var.net_config.gateway}"

  sshkeys = <<EOF
  ${local.ssh_key}
  EOF
}


