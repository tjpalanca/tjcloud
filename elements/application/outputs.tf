output "service_name" {
  value = kubernetes_service_v1.service.metadata.0.name
}

output "service_address" {
  value = "${kubernetes_service_v1.service.metadata.0.name}.${kubernetes_service_v1.service.metadata.0.namespace}"
}

output "cluster_ip" {
  value = kubernetes_service_v1.service.spec.0.cluster_ip
}

output "node_port" {
  value = kubernetes_service_v1.service.spec.0.port.0.node_port
}