terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.20.2"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.10.0"
    }
  }
}

locals {
  port = 8080
}

resource "postgresql_database" "keycloak" {
  name = "keycloak"
}

resource "kubernetes_namespace_v1" "keycloak" {
  metadata {
    name = "keycloak"
  }
}

module "keycloak" {
  source       = "../../elements/application"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  service_type = "ClusterIP"
  ports        = [local.port]
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
    port = local.port
  }]
}

module "keycloak_ingress" {
  source       = "../../elements/ingress"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  host         = var.keycloak.subdomain
  zone         = var.keycloak.cloudflare_zone
  service_name = module.keycloak.service_name
  service_port = local.port
  annotations = {
    "nginx.ingress.kubernetes.io/proxy-buffer-size" = "256k"
  }
}
