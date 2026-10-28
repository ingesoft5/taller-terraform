terraform {
  required_version = ">= 1.5.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pve_api_url
  pm_api_token_id     = var.pve_api_token_id
  pm_api_token_secret = var.pve_api_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "k8s_worker_node" {
  count       = var.node_count
  name        = "k8s-worker-0${count.index + 1}"
  target_node = var.target_node
  clone       = var.template_name

  cores   = 4
  memory  = 8192
  os_type = "cloud-init"

  ipconfig0 = "ip=10.147.20.${100 + count.index + 1}/24,gw=10.147.20.1"
  sshkeys   = var.ssh_public_key

  tags = "k8s,ingesoftv,worker"
}

output "node_names" {
  value = proxmox_vm_qemu.k8s_worker_node[*].name
}

output "node_ips" {
  value = [for i in range(var.node_count) : "10.147.20.${100 + i + 1}"]
}
