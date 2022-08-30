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
        node_name = var.node_name
        container {
          name    = var.name
          image   = var.image
          command = var.command
          dynamic "port" {
            for_each = var.ports
            content {
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
      }
    }
  }
}
