output "claim_name" {
  value = kubernetes_persistent_volume_claim_v1.volume_claim.metadata.0.name
}
