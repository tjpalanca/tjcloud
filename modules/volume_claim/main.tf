terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "do-block-storage"
    resources {
      requests = {
        storage = "${var.size}Gi"
      }
    }
  }
}
