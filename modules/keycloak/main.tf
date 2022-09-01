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
  source       = "../../resources/application"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  service_type = "ClusterIP"
  ports        = [local.port]
  replicas     = 1
  command_args = ["start-dev"]
  image        = "quay.io/keycloak/keycloak:${var.keycloak.version}"
  env_vars = {
    DB_VENDOR                = "postgres"
    DB_ADDR                  = var.database.internal_name
    DB_PORT                  = var.database.internal_port
    DB_DATABASE              = "keycloak"
    DB_USER                  = var.database.username
    DB_PASSWORD              = var.database.password
    PROXY_ADDRESS_FORWARDING = "true"
    KEYCLOAK_ADMIN           = var.keycloak.admin.username
    KEYCLOAK_ADMIN_PASSWORD  = var.keycloak.admin.password
    KC_PROXY                 = "edge"
  }
  readiness_probes = [{
    path = "/realms/master"
    port = local.port
  }]
}

module "keycloak_ingress" {
  source       = "../../resources/ingress"
  name         = "keycloak"
  namespace    = kubernetes_namespace_v1.keycloak.metadata.0.name
  host         = var.keycloak.subdomain
  zone         = var.keycloak.cloudflare_zone
  service_name = module.keycloak.service_name
  service_port = local.port
}

resource "keycloak_realm" "main" {
  realm = var.settings.realm_name
}
