variable "pve_api_url" {
  type    = string
  default = "https://pve.icesi.edu.co:8006/api2/json"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "target_node" {
  type    = string
  default = "pve-lab-01"
}

variable "template_name" {
  type    = string
  default = "ubuntu-2204-cloudinit-template"
}
