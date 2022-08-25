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

resource "kubernetes_deployment_v1" "postgres_database" {

  metadata {
    name      = local.name
    namespace = var.config.namespace
  }

  spec {
    replicas = 1
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
            sub_path   = "postgres/${var.config.name}"
          }
        }
        volume {
          name = local.name
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.postgres_pvc.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "postgres_pvc" {
  metadata {
    name      = local.name
    namespace = var.config.namespace
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
