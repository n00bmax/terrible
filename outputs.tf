# output "all-ips" {
#     value=  proxmox_vm_qemu.*[*].default_ipv4_address	
# }

# output "control_planes" {
#     value=  proxmox_vm_qemu.kube-control-plane[*].default_ipv4_address	
# }
# output "workers" {
#     value=  proxmox_vm_qemu.kube-worker[*].default_ipv4_address	
# }
# output "gpu-nodes" {
#     value=  proxmox_vm_qemu.kube-gpu-node[*].default_ipv4_address	
# }
# output "all-ips" {
#     value=  proxmox_vm_qemu.kube-control-plane[0].default_ipv4_address	
# }
# output "all-ips" {
#     value=  local.ssh_key
# }
