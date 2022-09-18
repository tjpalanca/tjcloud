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
  ports     = [8080]
  image     = "brndnmtthws/nginx-echo-headers:latest"
}

module "echo_gateway" {
  source                = "../../elements/gateway"
  host                  = "echo"
  zone_id               = var.cloudflare_zone_id
  service               = module.echo_application.service
  keycloak_realm_id     = var.keycloak_realm_id
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = var.default_client_scopes
}
