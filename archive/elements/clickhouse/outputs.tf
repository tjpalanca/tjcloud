output "credentials" {
  value = {
    internal_name = "${module.clickhouse_application.service.name}.${module.clickhouse_application.service.namespace}"
    internal_host = module.clickhouse_application.cluster_ip
    internal_port = local.port
    external_host = var.config.node_ip
    external_port = module.clickhouse_application.node_port
    username      = var.database.username
    password      = var.database.password
    database      = var.database.name
  }
  description = "Credentials to access this database"
}
