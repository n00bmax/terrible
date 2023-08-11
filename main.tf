### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("ansible-hosts.tmpl",
    {
      control-plane-ips = join("\n", module.control_plane.ipv4_addresses)
      worker-ips        = join("\n", module.worker.ipv4_addresses)
      gpu-node-ips      = join("\n", module.gpu.ipv4_addresses)
    }
  )
  filename = "hosts.cfg"
}


module "control_plane" {
  source    = "./proxmox-vm"
  vm_config = local.config.node_config.control_plane
}

module "worker" {
  source    = "./proxmox-vm"
  vm_config = local.config.node_config.worker
}

module "gpu" {
  source    = "./proxmox-vm"
  vm_config = local.config.node_config.gpu
}
