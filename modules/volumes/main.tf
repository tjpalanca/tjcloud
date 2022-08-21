terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "pgadmin" {
  metadata {
    name = "volumes"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "apps" {
  metadata {
    name      = "apps"
    namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "do-block-storage"
    volume_name        = "pvc-13e1990e-08eb-457e-bdfe-1173423fa768"
    resources {
      requests = {
        storage = "0Mi"
      }
    }
  }
}
