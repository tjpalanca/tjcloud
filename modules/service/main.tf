terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
  }
}

resource "kubernetes_service_v1" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = var.deployment
    }
    dynamic "port" {
      for_each = var.ports
      iterator = p
      content {
        name        = "port-${p.value}"
        port        = p.value
        target_port = p.value
      }
    }
  }
}
