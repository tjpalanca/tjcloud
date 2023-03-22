output "namespace" {
  value = {
    name = kubernetes_namespace_v1.namespace.metadata[0].name
  }
}
