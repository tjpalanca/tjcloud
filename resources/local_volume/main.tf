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
    storage_class_name               = "local-storage"
    persistent_volume_source {
      local {
        path = var.path
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = [var.node]
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
    storage_class_name = "local-storage"
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

resource "kubernetes_storage_class_v1" "local_storage" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
}
