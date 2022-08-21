terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "apps" {
  metadata {
    name = "apps"
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "do-block-storage"
    volume_name        = "pvc-13e1990e-08eb-457e-bdfe-1173423fa768"
    resources {
      requests = {
        storage = "50Mi"
      }
    }
  }
}
