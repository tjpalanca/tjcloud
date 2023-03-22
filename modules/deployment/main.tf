terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

resource "kubernetes_deployment_v1" "deployment" {
  timeouts {
    create = var.create_timeout
    update = var.update_timeout
  }
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        service_account_name = var.service_account_name
        container {
          name    = var.name
          image   = var.image
          command = var.command
          args    = var.args
          dynamic "port" {
            for_each = var.ports
            content {
              name           = "port-${port.value}"
              container_port = port.value
            }
          }
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }
          dynamic "liveness_probe" {
            for_each = var.liveness_probes
            iterator = probe
            content {
              http_get {
                path = probe.value.path
                port = probe.value.port
              }
              initial_delay_seconds = lookup(probe.value, "initial_delay_seconds", null)
              failure_threshold     = lookup(probe.value, "failure_threshold", null)
              period_seconds        = lookup(probe.value, "period_seconds", null)
            }
          }
          dynamic "readiness_probe" {
            for_each = var.readiness_probes
            iterator = probe
            content {
              http_get {
                path = probe.value.path
                port = probe.value.port
              }
              initial_delay_seconds = lookup(probe.value, "initial_delay_seconds", null)
              failure_threshold     = lookup(probe.value, "failure_threshold", null)
              period_seconds        = lookup(probe.value, "period_seconds", null)
            }
          }
          dynamic "resources" {
            for_each = (
              var.cpu_limit == null && var.mem_limit == null &&
              var.cpu_request == null && var.mem_request == null ?
              [] : [1]
            )
            content {
              limits = {
                cpu    = var.cpu_limit
                memory = var.mem_limit
              }
              requests = {
                cpu    = var.cpu_limit
                memory = var.mem_limit
              }
            }
          }
        }
      }
    }
  }
}
