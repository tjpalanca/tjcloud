resource "postgresql_database" "keycloak" {
  provider = postgresql.main
  name     = "keycloak"
}

resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

module "keycloak_image" {
  source        = "./modules/kaniko_build"
  name          = "keycloak"
  namespace     = kubernetes_namespace_v1.keycloak.metadata[0].name
  registry      = local.ghcr_registry
  build_context = "images/keycloak/"
  image_address = "ghcr.io/tjpalanca/tjcloud/keycloak"
  image_version = "v1.0"
  node          = local.main_node
  node_password = var.root_password
}

module "keycloak_application" {
  source       = "./modules/application"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata[0].name
  ports        = [8080]
  command_args = ["start-dev"]
  image        = module.keycloak_image.image.versioned
  env_vars = {
    KC_DB                   = "postgres"
    KC_DB_URL_HOST          = module.main_postgres_database.credentials.internal_name
    KC_DB_URL_PORT          = module.main_postgres_database.credentials.internal_port
    KC_DB_URL_DATABASE      = postgresql_database.keycloak.name
    KC_DB_USERNAME          = module.main_postgres_database.credentials.username
    KC_DB_PASSWORD          = module.main_postgres_database.credentials.password
    KEYCLOAK_ADMIN          = var.keycloak_admin_username
    KEYCLOAK_ADMIN_PASSWORD = var.keycloak_admin_password
    KC_PROXY                = "edge"
  }
  readiness_probes = [{
    path = "/realms/master"
    port = 8080
  }]
}

module "keycloak_ingress" {
  source       = "./modules/ingress"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata[0].name
  host         = var.keycloak_subdomain
  zone         = var.main_cloudflare_zone
  service_name = module.keycloak_application.service.name
  service_port = module.keycloak_application.service.port
  annotations = {
    "nginx.ingress.kubernetes.io/proxy-buffer-size" = "256k"
  }
}
