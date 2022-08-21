terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_persistent_volume_v1" "apps" {
  metadata {
    name = "apps"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    volume_mode        = "Filesystem"
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "do-block-storage"
    persistent_volume_source {
      csi {
        driver        = "dobs.csi.digitalocean.com"
        volume_handle = "apps"
        fs_type       = "ext4"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim_v1" "apps_claim" {
  metadata {
    name = "apps-claim"
  }
  spec {
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "do-block-storage"
    resources {
      requests = {
        storage = "50Mi"
      }
    }
  }
}
