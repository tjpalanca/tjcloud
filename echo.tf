module "echo" {
  source                = "./modules/echo"
  cloudflare_zone_id    = local.cloudflare.main_zone_id
  keycloak_realm_id     = module.keycloak_config.realms.main.id
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}
