module "pgadmin" {
  source                   = "./modules/pgadmin"
  pgadmin_default_username = var.pgadmin_default_username
  pgadmin_default_password = var.pgadmin_default_password
  pgadmin_cloudflare_zone  = var.main_cloudflare_zone
  keycloak_realm_name      = module.keycloak_config.realms.main.realm
  keycloak_url             = module.keycloak.url
  default_client_scopes    = [module.keycloak_config.client_scopes.groups.name]
  volume_name              = module.cluster.main_node_volume.label
  node_ip_address          = module.cluster.main_node.ip_address
  node_password            = var.root_password
  node_name                = module.cluster.main_node.label
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}