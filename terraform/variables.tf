
variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = true
}

variable "pm_host" {
  description = "The hostname or IP of the proxmox server"
  type        = string
  default="192.168.1.2"
}

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
  default     = "pve"
}

variable "pvt_key" {
  default= "~/.ssh/id_rsa"
}

variable "num_k3s_masters" {
  default = 1
}

variable "num_nfs" {
  default = 1
}
variable "num_proxy" {
  default = 1
}

variable "num_nfs_nodes_mem" {
  default = "4096"
}

variable "num_proxy_nodes_mem" {
  default = "1024"
}

variable "num_k3s_masters_mem" {
  default = "4096"
}
variable "num_proxy_nodes" {
  default = 3
}
variable "num_k3s_nodes" {
  default = 3
}
variable "pm_nfs_name" {
  default = "nfs"
}
variable "num_k3s_nodes_mem" {
  default = "4096"
}

variable "tamplate_vm_name" {
  default= "ubuntu-focal-cloudinit-template"
}

variable "nfs_ips" {
  description = "List of ip addresses for nfs nodes"
  default=[
  "192.168.1.3",
  ]
}
variable "proxy_ips" {
  description = "List of ip addresses for nfs nodes"
  default=[
  "192.168.1.10",
  ]
}
variable "master_ips" {
  description = "List of ip addresses for master nodes"
  default=[
  "192.168.1.11",
  ]
}

variable "worker_ips" {
  description = "List of ip addresses for worker nodes"
  default = [
  "192.168.1.21",
  "192.168.1.22",
  "192.168.1.23"
]
}
variable "disk" {
  default = "nvme"
}

variable "networkrange" {
  default = 24
}

variable "gateway" {
  default = "192.168.1.1"
}
