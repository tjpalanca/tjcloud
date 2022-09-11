terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
  }
}

resource "postgresql_database" "plausible_postgres" {
  name = "plausible"
}

resource "kubernetes_namespace_v1" "plausible" {
  metadata {
    name = "plausible"
  }
}

module "plausible_clickhouse" {
  source      = "../../elements/clickhouse"
  name        = "plausible-events-db"
  namespace   = kubernetes_namespace_v1.plausible.metadata[0].name
  node_name   = var.node_name
  volume_name = var.volume_name
  database = {
    name     = "plausible"
    username = var.clickhouse.username
    password = var.clickhouse.password
  }
  node_ip_address = var.node_ip_address
  node_password   = var.node_password
}
