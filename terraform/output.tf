
output "Master-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_master.*.default_ipv4_address}"]
}

output "worker-IPS" {
  value = ["${proxmox_vm_qemu.proxmox_vm_workers.*.default_ipv4_address}"]
}
output "Nfs-IPS" {
  value = ["${proxmox_vm_qemu.nfs-server.*.default_ipv4_address}"]
}
output "Proxy-IPS" {
  value = ["${proxmox_vm_qemu.proxy-server.*.default_ipv4_address}"]
}
