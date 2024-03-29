terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
  backend "pg" {
    #PGUSER,PGPASSWORD env variables required
    conn_str = "postgres://@192.168.1.7:15432/tfproxmox?sslmode=disable"    
  } 
}

provider "proxmox" {
  pm_api_url      = "https://${var.pm_host}:8006/api2/json"
  pm_tls_insecure = var.pm_tls_insecure
  pm_parallel     = 4
  pm_timeout      = 600
  #  pm_debug = true
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
