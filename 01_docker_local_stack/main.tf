terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

locals {
  app_prefix = "ingesoft-${var.environment}"
}

# 1. Red bridge interna aislada
resource "docker_network" "app_network" {
  name   = "${local.app_prefix}-net"
  driver = "bridge"
}

# 2. Volumen persistente para datos de BD
resource "docker_volume" "pg_data" {
  name = "${local.app_prefix}-pgdata"
}

# 3. Base de Datos PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:16-alpine"
  keep_locally = true
}

resource "docker_container" "postgres_db" {
  name  = "${local.app_prefix}-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=devops_db",
    "POSTGRES_USER=icesi_user",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.app_network.name
  }

  volumes {
    volume_name    = docker_volume.pg_data.name
    container_path = "/var/lib/postgresql/data"
  }

  restart = "unless-stopped"
}

# 4. Servidor de Caché Redis (Condicional con count)
resource "docker_image" "redis" {
  name         = "redis:7-alpine"
  keep_locally = true
}

resource "docker_container" "redis_cache" {
  count = var.enable_cache ? 1 : 0
  name  = "${local.app_prefix}-redis"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  restart = "unless-stopped"
}

# 5. Frontend / Reverse Proxy NGINX
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "nginx_frontend" {
  name  = "${local.app_prefix}-frontend"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = var.frontend_port
  }

  restart = "always"
  depends_on = [
    docker_container.postgres_db
  ]
}
