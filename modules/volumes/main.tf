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

resource "kubernetes_persistent_volume_v1" "apps" {
  metadata {
    name = "apps"
  }
  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes       = ["ReadWriteMany"]
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

# resource "kubernetes_persistent_volume_claim_v1" "apps" {
#   metadata {
#     name      = "apps"
#     namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
#   }
#   spec {
#     access_modes       = ["ReadWriteMany"]
#     storage_class_name = "do-block-storage"
#     volume_name        = "apps"
#     resources {
#       requests = {
#         storage = "1Ki"
#       }
#     }
#   }
# }
