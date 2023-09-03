### Create cluster nodes
module "control_plane" {
  source     = "./proxmox-vm"
  vm_config  = local.config.node_config.control_plane
  net_config = local.config.net_config
}

module "worker" {
  source     = "./proxmox-vm"
  vm_config  = local.config.node_config.worker
  net_config = local.config.net_config
}

module "gpu" {
  source     = "./proxmox-vm"
  vm_config  = local.config.node_config.gpu
  net_config = local.config.net_config
}

### Generate Ansible inventory file
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
