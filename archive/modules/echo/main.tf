terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "echo" {
  metadata {
    name = "echo"
  }
}

module "echo_application" {
  source    = "../../elements/application"
  name      = "echo"
  namespace = kubernetes_namespace_v1.echo.metadata.0.name
  ports     = [80]
  image     = "ealen/echo-server:latest"
  env_vars = {
    "ENABLE__ENVIRONMENT" = "false"
  }
}

module "echo_gateway" {
  source                = "../../elements/gateway"
  host                  = "echo"
  zone_id               = var.cloudflare_zone_id
  zone_name             = var.cloudflare_zone_name
  service               = module.echo_application.service
  keycloak_realm_id     = var.keycloak_realm_id
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = ["groups"]
}

module "echo_ingress" {
  source    = "../../elements/ingress"
  host      = "whoami"
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  service   = module.echo_application.service
}
