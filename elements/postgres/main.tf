terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  port = 5432
}

module "postgres" {
  source       = "../application"
  name         = var.config.name
  namespace    = var.config.namespace
  service_type = var.config.service_type
  ports        = [local.port]
  node_name    = var.config.node_name
  replicas     = 1
  image        = "postgres:${var.database.version}"
  env_vars = {
    POSTGRES_PASSWORD = var.database.password
    POSTGRES_USER     = var.database.username
    POSTGRES_DB       = var.database.name
  }
  volumes = [{
    volume_name = var.config.name
    mount_path  = "/var/lib/postgresql/data"
    host_path   = "/mnt/${var.config.volume_name}/postgres/${var.config.name}"
    mount_type  = "DirectoryOrCreate"
  }]
}
