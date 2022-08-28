terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  name = "postgres-${var.config.name}"
  path = "postgres/${var.config.name}"
  port = 5432
}

resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name      = local.name
    namespace = var.config.namespace
  }
  spec {
    selector = {
      app = local.name
    }
    port {
      port        = local.port
      target_port = local.port
    }
  }
}

resource "kubernetes_deployment_v1" "postgres_database" {
  metadata {
    name      = local.name
    namespace = var.config.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.name
      }
    }
    template {
      metadata {
        labels = {
          app = local.name
        }
      }
      spec {
        container {
          name  = "database"
          image = "postgres:${var.database.db_version}"
          port {
            container_port = local.port
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.database.password
          }
          env {
            name  = "POSTGRES_USER"
            value = var.database.username
          }
          env {
            name  = "POSTGRES_DB"
            value = var.database.db_name
          }
          volume_mount {
            name       = local.name
            mount_path = "/var/lib/postgresql"
            sub_path   = local.path
          }
        }
        volume {
          name = local.name
          persistent_volume_claim {
            claim_name = module.postgres_volume.claim_name
          }
        }
      }
    }
  }
}

module "postgres_volume" {
  source = "../local_volume"
  name   = local.name
  path   = local.path
  node   = var.config.node
  size   = var.config.storage
}
