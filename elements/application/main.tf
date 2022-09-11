terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    type = var.service_type
    selector = {
      app = var.name
    }
    dynamic "port" {
      for_each = var.ports
      content {
        name        = "port-${port.value}"
        port        = port.value
        target_port = port.value
      }
    }
  }
}

resource "kubernetes_deployment_v1" "deployment" {
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
        restart_policy       = var.restart_policy
        service_account_name = var.service_account_name
        node_name            = var.node_name
        container {
          name    = var.name
          image   = var.image
          command = var.command
          args    = var.command_args
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
          dynamic "volume_mount" {
            for_each = var.volumes
            iterator = volume
            content {
              name       = volume.value.volume_name
              mount_path = volume.value.mount_path
            }
          }
          dynamic "volume_mount" {
            for_each = var.config_maps
            iterator = config_map
            content {
              name       = config_map.value.config_map_name
              mount_path = config_map.value.mount_path
              sub_path   = config_map.value.sub_path
              read_only  = config_map.value.read_only
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
          security_context {
            privileged = var.privileged
          }
          resources {
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
        dynamic "volume" {
          for_each = var.volumes
          iterator = volume
          content {
            name = volume.value.volume_name
            host_path {
              path = volume.value.host_path
              type = volume.value.mount_type
            }
          }
        }
        dynamic "volume" {
          for_each = toset([for cf in var.config_maps : cf.config_map_name])
          iterator = config_map
          content {
            name = config_map.value
            config_map {
              name = config_map.value
            }
          }
        }
        security_context {
          run_as_user  = var.run_as.run_as_user
          run_as_group = var.run_as.run_as_group
          fs_group     = var.run_as.fs_group
        }
      }
    }
  }
}
