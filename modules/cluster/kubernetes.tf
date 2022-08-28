resource "kubernetes_storage_class_v1" "local_storage" {
  metadata {
    name = "local-storage"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Retain"
  depends_on = [
    linode_lke_cluster.cluster,
    null_resource.reset_root_password
  ]
}
