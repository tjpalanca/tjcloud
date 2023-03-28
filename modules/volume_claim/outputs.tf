output "name" {
  value = kubernetes_persistent_volume_claim_v1.pvc.metadata[0].name
}

output "namespace" {
  value = kubernetes_persistent_volume_claim_v1.pvc.metadata[0].namespace
}
