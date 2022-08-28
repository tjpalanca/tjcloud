resource "kubernetes_storage_class_v1" "local_storage" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
  depends_on = [
    time_sleep.cluster_ready
  ]
}
