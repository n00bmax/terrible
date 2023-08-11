output "ipv4_addresses" {
    value= proxmox_vm_qemu.kube-node[*].default_ipv4_address
}