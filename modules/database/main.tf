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
  source = "../../resources/postgres"
  database = {
    username   = var.main_postgres_username
    password   = var.main_postgres_password
    db_name    = var.main_postgres_database
    db_version = "14"
  }
  config = {
    name      = "main"
    node      = var.main_node
    storage   = "5Gi"
    namespace = kubernetes_namespace_v1.database.metadata.0.name
  }
}
