variable "environment" {
  description = "Nombre del entorno de despliegue (dev, qa, prod)"
  type        = string
  default     = "lab-205m"
}

variable "frontend_port" {
  description = "Puerto expuesto en el host para el frontend Nginx"
  type        = number
  default     = 8080
}

variable "db_password" {
  description = "Contraseña para el usuario de PostgreSQL"
  type        = string
  default     = "IcesiDevOps2026!"
  sensitive   = true
}

variable "enable_cache" {
  description = "Habilita o deshabilita el contenedor de caché Redis"
  type        = bool
  default     = true
}
