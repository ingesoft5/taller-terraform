variable "pve_api_url" {
  description = "URL de la API REST del hipervisor Proxmox VE (puerto 8006)"
  type        = string
  default     = "https://pve.icesi.edu.co:8006/api2/json"
}

variable "pve_api_token_id" {
  description = "Identificador del API Token institucional (formato: usuario@realm!nombre_token)"
  type        = string
  default     = "terraform@pve!taller-token"
}

variable "pve_api_token_secret" {
  description = "Secreto UUID del API Token generado en la interfaz web de Proxmox VE"
  type        = string
  sensitive   = true
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "node_count" {
  description = "Cantidad de nodos virtuales a aprovisionar para el clúster"
  type        = number
  default     = 3
}

variable "target_node" {
  description = "Nombre del nodo físico en el clúster Proxmox donde se crearán las VMs"
  type        = string
  default     = "pve-lab-01"
}

variable "template_name" {
  description = "Nombre de la plantilla Cloud-Init base para clonación rápida"
  type        = string
  default     = "ubuntu-2204-cloudinit-template"
}

variable "ssh_public_key" {
  description = "Clave pública SSH inyectada mediante Cloud-Init para acceso remoto sin contraseña"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG5kDevOpsIcesi2026k8sStudentKey estudiante@icesi.edu.co"
}
