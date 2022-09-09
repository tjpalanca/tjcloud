module "keycloak_image" {
  source        = "./elements/image"
  name          = "keycloak"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "modules/keycloak/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/keycloak"
  image_version = "v1.0"
  node          = module.cluster.main_node
  node_password = var.root_password
  depends_on = [
    module.cluster
  ]
}

module "keycloak" {
  source = "./modules/keycloak"
  providers = {
    postgresql = postgresql.main
  }
  database = module.database.main_postgres_database_credentials
  keycloak = {
    image           = module.keycloak_image.image.versioned
    cloudflare_zone = var.main_cloudflare_zone
    subdomain       = var.keycloak_subdomain
  }
  admin = {
    username = var.keycloak_admin_username
    password = var.keycloak_admin_password
  }
  depends_on = [
    module.cluster,
    module.keycloak_image
  ]
}

module "keycloak_config" {
  source = "./modules/keycloak-config"
  settings = {
    realm_name         = var.cluster_name
    realm_display_name = var.keycloak_realm_display_name
    admin_emails       = var.admin_emails
  }
  identity_providers = {
    google = {
      client_id     = var.google_client_id
      client_secret = var.google_client_secret
    }
  }
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}
