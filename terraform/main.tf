resource "proxmox_vm_qemu" "proxmox_vm_master" {
  count       = var.num_k3s_masters
  name        = "k3s-master-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_masters_mem
  cores       = 4
  ipconfig0 = "ip=${var.master_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "50G"
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
  count       = var.num_k3s_nodes
  name        = "k3s-worker-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_k3s_nodes_mem
  cores       = 4
  ipconfig0 = "ip=${var.worker_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "50G"
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
resource "proxmox_vm_qemu" "nfs-server" {
  count       = var.num_nfs
  name        = "nfs-server-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_nfs_nodes_mem
  cores       = 4
  ipconfig0 = "ip=${var.nfs_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "25G"
  }
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "500G"
    format  = "ext4"
    
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
resource "proxmox_vm_qemu" "proxy-server" {
  count       = var.num_proxy
  name        = "proxy-server-${count.index}"
  target_node = var.pm_node_name
  clone       = var.tamplate_vm_name
  os_type     = "cloud-init"
  agent       = 1
  memory      = var.num_proxy_nodes_mem
  cores       = 4
  ipconfig0 = "ip=${var.proxy_ips[count.index]}/${var.networkrange},gw=${var.gateway}"
  disk {
    storage = var.disk
    type    = "scsi"
    size    = "25G"
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
