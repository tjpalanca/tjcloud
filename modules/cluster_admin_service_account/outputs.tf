output "name" {
  value = kubernetes_service_account_v1.cluster_admin.metadata[0].name
}
