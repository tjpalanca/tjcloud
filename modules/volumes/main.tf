terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "volumes" {
  metadata {
    name = "volumes"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "databases" {
  metadata {
    name      = "databases"
    namespace = kubernetes_namespace_v1.volumes.metadata.0.name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "do-block-storage"
    resources {
      requests = {
        storage = "1Ki"
      }
    }
  }
}
