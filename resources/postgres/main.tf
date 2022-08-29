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

resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name      = var.config.name
    namespace = var.config.namespace
  }
  spec {
    selector = {
      app = var.config.name
    }
    port {
      port        = local.port
      target_port = local.port
    }
  }
}

resource "kubernetes_deployment_v1" "postgres_database" {
  metadata {
    name      = var.config.name
    namespace = var.config.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.config.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.config.name
        }
      }
      spec {
        node_name = var.config.node_name
        container {
          name  = "postgres-database"
          image = "postgres:${var.database.version}"
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
            value = var.database.name
          }
          volume_mount {
            name       = var.config.name
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
          name = var.config.name
          host_path {
            path = "/mnt/${var.config.volume_name}/postgres/${var.config.name}"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}
