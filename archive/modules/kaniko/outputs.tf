output "namespace" {
  value = kubernetes_namespace_v1.kaniko.metadata.0.name
}
