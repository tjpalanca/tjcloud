terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

locals {
  clickhouse_database_name = "plausible"
}

resource "postgresql_database" "plausible_postgres" {
  name = "plausible"
}

resource "kubernetes_namespace_v1" "plausible" {
  metadata {
    name = "plausible"
  }
}

# module "plausible_clickhouse" {
#   source      = "../../elements/clickhouse"
#   name        = "plausible-events-db"
#   namespace   = kubernetes_namespace_v1.plausible.metadata[0].name
#   node_name   = var.node_name
#   volume_name = var.volume_name
#   database = {
#     name     = local.clickhouse_database_name
#     username = var.clickhouse.username
#     password = var.clickhouse.password
#   }
#   node_ip_address = var.node_ip_address
#   node_password   = var.node_password
# }

# module "plausible_application" {
#   source    = "../../elements/application"
#   name      = "plausible"
#   namespace = kubernetes_namespace_v1.plausible.metadata[0].name
#   image     = "plausible/analytics:latest"
#   ports     = [8000]
#   command   = ["/bin/sh", "-c"]
#   command_args = [
#     join(" && ", [
#       "sleep 10",
#       "/entrypoint.sh db createdb",
#       "/entrypoint.sh db migrate",
#       "/entrypoint.sh db init-admin",
#       "/entrypoint.sh run"
#     ])
#   ]
#   env_vars = {
#     DATABASE_URL            = "postgres://${var.postgres.username}:${var.postgres.password}@${var.postgres.internal_host}/${postgresql_database.plausible_postgres.name}"
#     CLICKHOUSE_DATABASE_URL = "http://${module.plausible_clickhouse.service.name}:${module.plausible_clickhouse.service.port}/${local.clickhouse_database_name}"
#     GOOGLE_CLIENT_ID        = var.google_client_id
#     GOOGLE_CLIENT_SECRET    = var.google_client_secret
#   }
# }
