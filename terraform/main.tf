resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = 1
  name        = "k3s-master-${count.index}-${var.env}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = 4
  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  ipconfig1 = "ip=${var.secondary_master_ips[count.index]}/${var.networkrange}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "50G"
    discard = "on"
    cache   ="directsync"
    
  }
  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      network
    ]
  }

}

resource "proxmox_vm_qemu" "proxmox_vm_workers" {
  count       = 3
  name        = "k3s-worker-${count.index}-${var.env}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = 6
  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  ipconfig1 = "ip=${var.secondary_worker_ips[count.index]}/${var.networkrange}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "50G"
    discard = "on"
    cache   ="directsync"
  }
  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      disk,
      network
    ]
  }
}

data "template_file" "k8s" {
  template = file("./templates/k8s.tpl")
  vars = {
    k3s_master_ip = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_master : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
    k3s_node_ip   = "${join("\n", [for instance in proxmox_vm_qemu.proxmox_vm_workers : join("", [instance.default_ipv4_address, " ansible_ssh_private_key_file=", var.pvt_key])])}"
  }
}

resource "local_file" "k8s_file" {
  content  = data.template_file.k8s.rendered
  filename = "../inventory/my-cluster/hosts.ini"
}

resource "local_file" "var_file" {
  source   = "../inventory/sample/group_vars/all.yml"
  filename = "../inventory/my-cluster/group_vars/all.yml"
}
