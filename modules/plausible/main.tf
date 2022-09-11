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
  env_vars = {
    POSTGRES_USER           = var.postgres.username
    POSTGRES_PASSWORD       = var.postgres.password
    CLICKHOUSE_USER         = var.clickhouse.username
    CLICKHOUSE_PASSWORD     = var.clickhouse.password
    DATABASE_URL            = "postgres://${var.postgres.username}:${var.postgres.password}@${var.postgres.internal_host}/${postgresql_database.plausible_postgres.name}"
    CLICKHOUSE_DATABASE_URL = "http://${var.clickhouse.internal_host}:${var.clickhouse.internal_port}/plausible"
    SMTP_HOST_ADDR          = var.smtp_host
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

resource "kubernetes_deployment_v1" "deployment" {
  metadata {
    name = "plausible"
    labels = {
      app = "plausible"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "plausible"
      }
    }
    template {
      metadata {
        labels = {
          app = "plausible"
        }
      }
      spec {
        restart_policy = "Always"
        security_context {
          run_as_user  = 1000
          run_as_group = 1000
          fs_group     = 1000
        }
        init_container {
          name    = "plausible-init"
          image   = "plausible/analytics:latest"
          command = ["/bin/sh", "-c"]
          args = [join(" && ", [
            "sleep 10",
            "/entrypoint.sh db createdb",
            "/entrypoint.sh db migrate",
            "/entrypoint.sh db init-admin"
          ])]
          dynamic "env" {
            for_each = local.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          security_context {
            allow_privilege_escalation = false
          }
          resources {
            limits = {
              memory = "2Gi"
              cpu    = "1500m"
            }
            requests = {
              memory = "50Mi"
              cpu    = "10m"
            }
          }
        }
        container {
          name  = "plausible"
          image = "plausible/analytics:latest"
          port {
            container_port = 8000
          }
          dynamic "env" {
            for_each = local.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          security_context {
            allow_privilege_escalation = false
          }
          resources {
            limits = {
              memory = "2Gi"
              cpu    = "1500m"
            }
            requests = {
              memory = "140Mi"
              cpu    = "10m"
            }
          }
          readiness_probe {
            http_get {
              path = "/api/health"
              port = 8000
            }
            initial_delay_seconds = 35
            failure_threshold     = 3
            period_seconds        = 10
          }
          liveness_probe {
            http_get {
              path = "/api/health"
              port = 8000
            }
            initial_delay_seconds = 45
            failure_threshold     = 3
            period_seconds        = 10
          }
        }
      }
    }
  }
}
