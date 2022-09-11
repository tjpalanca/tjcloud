module "code_image" {
  source        = "./elements/image"
  name          = "code"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "modules/code/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/code"
  image_version = "v1.0"
  node          = module.cluster.main_node
  node_password = var.root_password
  build_args = {
    DEFAULT_USER = var.user_name
  }
  post_copy_commands = [
    "chmod +x scripts/*"
  ]
}

module "code" {
  source                  = "./modules/code"
  cloudflare_zone         = var.main_cloudflare_zone
  image                   = module.code_image.image.latest
  user_name               = var.user_name
  github_pat              = var.github_pat
  extensions_gallery_json = var.extensions_gallery_json
  keycloak_realm_id       = module.keycloak_config.realms.main.id
  keycloak_url            = module.keycloak.url
  default_client_scopes   = [module.keycloak_config.client_scopes.groups.name]
  volume_name             = module.cluster.main_node_volume.label
  node_ip_address         = module.cluster.main_node.ip_address
  node_password           = var.root_password
  node_name               = module.cluster.main_node.label
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}
