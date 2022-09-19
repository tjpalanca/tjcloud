module "metrics_server" {
  source = "./modules/metrics_server"
}

module "dashboard" {
  source                = "./modules/dashboard"
  namespace             = "dashboard"
  cloudflare_zone_id    = var.main_cloudflare_zone_id
  cloudflare_zone_name  = var.main_cloudflare_zone_name
  keycloak_realm_id     = module.keycloak_config.realms.main.id
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.metrics_server
  ]
}
