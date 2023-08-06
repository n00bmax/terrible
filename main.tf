resource "proxmox_vm_qemu" "kube-control-plane" {
  count       = var.cluster_config.control_plane.node_count
  name        = "kube-control-0${count.index + 1}"
  target_node = "UditSuperServer"
  # thanks to Brian on YouTube for the vmid tip
  # http://www.youtube.com/channel/UCTbqi6o_0lwdekcp-D6xmWw
  vmid = "40${count.index + 1}"

  clone = "ubuntu-cloud-init"
  #  ciuser = "udit"
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
    size     = "20G"
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
  ipconfig0 = "ip=${trimsuffix(var.cluster_config.ip_base,"0")}${var.cluster_config.control_plane.ip_offset+count.index + 1}/${var.cluster_config.netmask},gw=${var.cluster_config.gateway}"

  sshkeys   = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-worker" {
  count       = var.cluster_config.worker.node_count
  name        = "kube-worker-0${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "50${count.index + 1}"
  clone       = "ubuntu-cloud-init"

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

  ipconfig0 = "ip=${trimsuffix(var.cluster_config.ip_base,"0")}${var.cluster_config.worker.ip_offset+count.index + 1}/${var.cluster_config.netmask},gw=${var.cluster_config.gateway}"
  
  sshkeys   = <<EOF
  ${var.ssh_key}
  EOF
}

resource "proxmox_vm_qemu" "kube-gpu-node" {
  count       = var.cluster_config.gpu.node_count > 0 ? var.cluster_config.gpu.node_count : 0
  name        = "kube-gpu-node-0${count.index + 1}"
  target_node = "UditSuperServer"
  vmid        = "701"

  clone    = "ubuntu-cloud-init"
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
  ipconfig0 = "ip=${trimsuffix(var.cluster_config.ip_base,"0")}${var.cluster_config.gpu.ip_offset+count.index + 1}/${var.cluster_config.netmask},gw=${var.cluster_config.gateway}"

  sshkeys   = <<EOF
  ${var.ssh_key}
  EOF
}

# resource "local_file" "hosts_cfg" {
#   content = templatefile("ansible-hosts.tpl",
#     {
#       kube-worker = kube-worker.kafka_processor.*.public_ip
#       kube-control_plane = aws_instance.test_client.*.public_ip
#     }
#   )
#   filename = "hosts.cfg"
# }
