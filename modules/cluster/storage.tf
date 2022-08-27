resource "kubernetes_persistent_volume_claim_v1" "cluster_data" {
  metadata {
    name = "${var.cluster_name}-data"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
    storage_class_name = "linode-block-storage-retain"
  }
}
