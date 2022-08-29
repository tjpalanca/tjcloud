output "credentials" {
  value = {
    internal_host = kubernetes_service_v1.postgres_service.spec.0.cluster_ip
    internal_port = local.port
    external_host = var.config.node_ip
    external_port = kubernetes_service_v1.postgres_service.spec.0.port.0.node_port
    username      = var.database.username
    password      = var.database.password
    database      = var.database.name
  }
  description = "Credentials to access this database"
}
