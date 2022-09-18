terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

resource "postgresql_database" "keycloak" {
  name = "keycloak"
}

resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

module "keycloak_application" {
  source       = "../../elements/application"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  service_type = "ClusterIP"
  ports        = [8080]
  replicas     = 1
  command_args = ["start-dev"]
  image        = var.keycloak.image
  env_vars = {
    KC_DB                   = "postgres"
    KC_DB_URL_HOST          = var.database.internal_name
    KC_DB_URL_PORT          = var.database.internal_port
    KC_DB_URL_DATABASE      = postgresql_database.keycloak.name
    KC_DB_USERNAME          = var.database.username
    KC_DB_PASSWORD          = var.database.password
    KEYCLOAK_ADMIN          = var.admin.username
    KEYCLOAK_ADMIN_PASSWORD = var.admin.password
    KC_PROXY                = "edge"
  }
  readiness_probes = [{
    path = "/realms/master"
    port = 8080
  }]
}

data "cloudflare_zone" "zone" {
  zone_id = var.keycloak.cloudflare_zone_id
}

module "keycloak_ingress" {
  source  = "../../elements/ingress"
  host    = var.keycloak.subdomain
  zone_id = var.keycloak.cloudflare_zone_id
  service = module.keycloak_application.service
  annotations = {
    "nginx.ingress.kubernetes.io/proxy-buffer-size" = "256k"
    "nginx.ingress.kubernetes.io/enable-cors"       = "true"
  }
}
