module "database" {
  source                        = "./modules/database"
  main_postgres_username        = var.main_postgres_username
  main_postgres_database        = var.main_postgres_database
  main_postgres_password        = var.main_postgres_password
  main_postgres_node_name       = module.cluster.main_node.label
  main_postgres_node_ip         = module.cluster.main_node.ip_address
  main_postgres_volume_name     = module.cluster.main_node_volume.label
  main_clickhouse_database      = var.main_clickhouse_database
  main_clickhouse_username      = var.main_clickhouse_username
  main_clickhouse_password      = var.main_clickhouse_password
  main_clickhouse_node_ip       = module.cluster.main_node.ip_address
  main_clickhouse_node_name     = module.cluster.main_node.label
  main_clickhouse_volume_name   = module.cluster.main_node_volume.label
  main_clickhouse_node_password = var.root_password
  depends_on = [
    module.cluster
  ]
}
