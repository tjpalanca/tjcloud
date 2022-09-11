module "echo" {
  source                = "./modules/echo"
  cloudflare_zone       = var.main_cloudflare_zone
  keycloak_realm_id     = module.keycloak_config.realms.main.id
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}
