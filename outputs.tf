output "ipv4" {
    value=  proxmox_vm_qemu.kube-worker[0].default_ipv4_address	
}