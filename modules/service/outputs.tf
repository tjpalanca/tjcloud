output "name" {
  value = kubernetes_service_v1.service.metadata[0].name
}

output "namespace" {
  value = kubernetes_service_v1.service.metadata[0].namespace
}

output "ports" {
  value = var.ports
}
