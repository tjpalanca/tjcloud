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
  env_vars = {
    BASE_URL                = "https://${var.subdomain}.${var.cloudflare_zone}"
    POSTGRES_USER           = var.postgres.username
    POSTGRES_PASSWORD       = var.postgres.password
    CLICKHOUSE_USER         = var.clickhouse.username
    CLICKHOUSE_PASSWORD     = var.clickhouse.password
    DATABASE_URL            = "postgres://${var.postgres.username}:${var.postgres.password}@${var.postgres.internal_host}/${postgresql_database.plausible_postgres.name}"
    CLICKHOUSE_DATABASE_URL = "http://${var.clickhouse.internal_host}:${var.clickhouse.internal_port}/plausible"
    SMTP_HOST_ADDR          = var.smtp_host
    DISABLE_REGISTRATION    = "true"
    ADMIN_USER_EMAIL        = var.admin_user.email
    ADMIN_USER_NAME         = var.admin_user.name
    ADMIN_USER_PWD          = var.admin_user.password
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
    name      = "plausible"
    namespace = kubernetes_namespace_v1.plausible.metadata[0].name
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

# module "plausible_ingress" {
#   source = "../../elements/ingress"
#   service = {
#     namespace = kubernetes_namespace_v1.plausible.metadata[0].name
#   }
# }

# variable "service" {
#   type = object({
#     name      = string
#     port      = number
#     namespace = string
#   })
#   description = "Details of the service proxied"
# }

# variable "host" {
#   type        = string
#   default     = null
#   description = "Host name to respond to"
# }

# variable "zone" {
#   type        = string
#   description = "Cloudflare zone, also the TLD"
# }

# variable "path" {
#   type        = string
#   default     = "/"
#   description = "Subpath to serve the ingress at"
# }

# variable "ingress_class_name" {
#   type        = string
#   default     = "nginx"
#   description = "Class of the ingress to be provisioned"
# }

# variable "annotations" {
#   type        = map(string)
#   default     = {}
#   description = "Additional annotations to the ingress"
# }
