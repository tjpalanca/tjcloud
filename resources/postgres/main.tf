terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

}

locals {
  name = "${var.config.name}-postgres"
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
      port        = 5432
      target_port = 5432
    }
  }

}

resource "kubernetes_stateful_set_v1" "postgres_database" {

  metadata {
    name      = local.name
    namespace = var.config.namespace
  }

  spec {
    replicas     = 1
    service_name = local.name
    selector {
      match_labels = {
        "app" = local.name
      }
    }
    template {
      metadata {
        labels = {
          "app" = local.name
        }
      }
      spec {
        container {
          name  = "database"
          image = "postgres:${var.database.db_version}"
          port {
            container_port = 5432
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
          }
        }
      }
    }
    volume_claim_template {
      metadata {
        name = local.name
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "do-block-storage"
        resources {
          requests = {
            storage = var.database.storage
          }
        }
      }
    }

  }
}
