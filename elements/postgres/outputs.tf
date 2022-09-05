output "credentials" {
  value = {
    internal_name = module.postgres.service.address
    internal_host = module.postgres.cluster_ip
    internal_port = local.port
    external_host = var.config.node_ip
    external_port = module.postgres.node_port
    username      = var.database.username
    password      = var.database.password
    database      = var.database.name
  }
  description = "Credentials to access this database"
}
