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
        annotations = {
          "deployment.kubernetes.io/build_context_hash" = (
            var.build_context == null ?
            null :
            sha1(
              join(
                "", [
                  for f in fileset(var.build_context, "**") :
                  filesha1("${var.build_context}/${f}")
                ]
              )
            )
          )
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
          dynamic "volume_mount" {
            for_each = var.mount_docker_socket ? [1] : []
            content {
              name       = "docker"
              mount_path = "/var/run/docker.sock"
            }
          }
          dynamic "volume_mount" {
            for_each = var.mounts
            iterator = m
            content {
              mount_path = m.value.mount_path
              name       = m.value.claim_name
              sub_path   = m.value.volume_path
            }
          }
          security_context {
            privileged = var.privileged
          }
        }
        dynamic "init_container" {
          for_each = var.mounts
          iterator = m
          content {
            name    = "${replace(m.value.volume_path, "/", "-")}-${m.value.owner_uid}"
            image   = "busybox"
            command = ["/bin/chown", m.value.owner_uid, "/data"]
            volume_mount {
              name       = m.value.claim_name
              mount_path = "/data"
              sub_path   = m.value.volume_path
            }
          }
        }
        dynamic "volume" {
          for_each = var.mount_docker_socket ? [1] : []
          content {
            name = "docker"
            host_path {
              path = "/var/run/docker.sock"
              type = "Socket"
            }
          }
        }
        dynamic "volume" {
          for_each = toset(distinct([for v in var.mounts : v.claim_name]))
          iterator = v
          content {
            name = v.value
            persistent_volume_claim {
              claim_name = v.value
            }
          }
        }
      }
    }
  }
}
