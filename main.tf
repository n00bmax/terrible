resource "proxmox_vm_qemu" "kube-control-plane" {
  count       = local.config.nodes.control_plane.node_count
  name        = "${local.config.control_plane_config.name_prefix}${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "${local.config.control_plane_config.vmid_prefix}${count.index + 1}"

  clone    = var.template_name
  agent    = 1
  os_type  = "cloud-init"
  cores    = local.config.control_plane_config.cores
  sockets  = local.config.control_plane_config.sockets
  cpu      = local.config.control_plane_config.cpu
  memory   = local.config.control_plane_config.memory
  scsihw   = local.config.control_plane_config.scsihw
  bootdisk = local.config.control_plane_config.bootdisk

  disk {
    slot     = local.config.control_plane_config.disk.slot
    size     = local.config.control_plane_config.disk.size
    type     = local.config.control_plane_config.disk.type
    storage  = local.config.control_plane_config.disk.storage
    iothread = local.config.control_plane_config.disk.iothread
  }

  network {
    model  = local.config.control_plane_config.network.model
    bridge = local.config.control_plane_config.network.bridge
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  #   ipconfig0 = "ip=10.10.5.7${count.index + 1}/12,gw=10.0.0.1"
  ipconfig0 = "ip=${trimsuffix(local.config.net_config.ip_base, "0")}${local.config.nodes.control_plane.ip_offset + count.index + 1}/${local.config.net_config.netmask},gw=${local.config.net_config.gateway}"

  sshkeys = <<EOF
  ${local.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-worker" {
  count       = local.config.nodes.worker.node_count
  name        = "kube-worker-0${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "50${count.index + 1}"
  clone       = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  disk {
    slot     = 0
    size     = "10G"
    type     = "scsi"
    storage  = "local-zfs"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  #   ipconfig0 = "ip=10.10.5.7${count.index + 1}/12,gw=10.0.0.1"
  ipconfig0 = "ip=${trimsuffix(local.config.net_config.ip_base, "0")}${local.config.nodes.worker.ip_offset + count.index + 1}/${local.config.net_config.netmask},gw=${local.config.net_config.gateway}"

  sshkeys = <<EOF
  ${local.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-gpu-node" {
  count       = local.config.nodes.gpu.node_count
  name        = "kube-gpu-node-0${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "70${count.index + 1}"

  clone    = var.template_name
  agent    = 1
  os_type  = "cloud-init"
  cores    = 4
  sockets  = 1
  cpu      = "host"
  memory   = 8192
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  disk {
    slot     = 0
    size     = "10G"
    type     = "scsi"
    storage  = "local-zfs"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  #   ipconfig0 = "ip=10.10.5.8${count.index + 1}/12,gw=10.0.0.1"
  ipconfig0 = "ip=${trimsuffix(local.config.net_config.ip_base, "0")}${local.config.nodes.gpu.ip_offset + count.index + 1}/${local.config.net_config.netmask},gw=${local.config.net_config.gateway}"

  sshkeys = <<EOF
  ${local.ssh_key}
  EOF
}


### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("ansible-hosts.tmpl",
    {
      control-plane-ips = join("\n", proxmox_vm_qemu.kube-control-plane[*].default_ipv4_address)
      worker-ips        = join("\n", proxmox_vm_qemu.kube-worker[*].default_ipv4_address)
      gpu-node-ips      = join("\n", proxmox_vm_qemu.kube-gpu-node[*].default_ipv4_address)
    }
  )
  filename = "hosts.cfg"
}
