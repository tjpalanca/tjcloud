terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_persistent_volume_v1" "volume" {
  metadata {
    name = var.name
  }
  spec {
    capacity = {
      storage = var.size
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = var.storage_class_name
    persistent_volume_source {
      local {
        path = var.node_path
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = [var.node_name]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "volume_claim" {
  metadata {
    name = var.name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = var.size
      }
    }
  }
  depends_on = [
    kubernetes_persistent_volume_v1.volume
  ]
}
