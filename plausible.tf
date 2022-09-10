module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  node_name   = module.cluster.main_node.label
  volume_name = module.cluster.main_node_volume.label
  clickhouse = {
    username = var.plausible_clickhouse_username
    password = var.plausible_clickhouse_password
  }
  node_ip_address = module.cluster.main_node.node_ip_address
  node_password   = var.root_password
}
