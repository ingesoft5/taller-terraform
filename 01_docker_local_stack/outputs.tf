output "network_id" {
  description = "ID de la red bridge interna aprovisionada"
  value       = docker_network.app_network.id
}

output "frontend_url" {
  description = "URL para acceder al servicio frontend"
  value       = "http://localhost:${var.frontend_port}"
}

output "database_endpoint" {
  description = "Nombre DNS interno y puerto de la base de datos"
  value       = "${docker_container.postgres_db.name}:5432"
}

output "cache_enabled" {
  description = "Indica si la caché Redis fue aprovisionada"
  value       = var.enable_cache
}
