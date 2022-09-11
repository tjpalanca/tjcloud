module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  node_name            = module.cluster.main_node.label
  volume_name          = module.cluster.main_node_volume.label
  node_ip_address      = module.cluster.main_node.ip_address
  node_password        = var.root_password
  google_client_id     = var.google_client_id
  google_client_secret = var.google_client_secret
}
