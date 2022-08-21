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

# resource "digitalocean_volume" "apps" {
#   region                  = "sgp1"
#   name                    = "apps"
#   size                    = 1
#   initial_filesystem_type = "ext4"
# }

resource "kubernetes_persistent_volume_v1" "apps" {
  metadata {
    name = "apps"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "do-block-storage"
    persistent_volume_source {
      csi {
        driver        = "dobs.csi.digitalocean.com"
        volume_handle = "ecb75916-67ee-4f7d-a5e1-4e9a261c3c59"
        fs_type       = "ext4"
      }
    }
  }
}
