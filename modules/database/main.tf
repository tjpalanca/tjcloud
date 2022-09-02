terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "database" {
  metadata {
    name = "database"
  }
}

module "main_postgres_database" {
  source = "../../elements/postgres"
  database = {
    username = var.main_postgres_username
    password = var.main_postgres_password
    name     = var.main_postgres_database
    version  = "14"
  }
  config = {
    name         = "main-postgres-database"
    storage_size = "5Gi"
    namespace    = kubernetes_namespace_v1.database.metadata.0.name
    volume_name  = var.main_postgres_volume_name
    node_name    = var.main_postgres_node_name
    node_ip      = var.main_postgres_node_ip
    service_type = "NodePort"
  }
}
