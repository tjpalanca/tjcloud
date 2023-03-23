output "ports" {
  value = var.ports
}

output "name" {
  value = kubernetes_deployment_v1.deployment.metadata[0].name
}
