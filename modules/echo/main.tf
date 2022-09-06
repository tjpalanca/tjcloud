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
  ports     = [5050]
  image     = "brndnmtthws/nginx-echo-headers:latest"
  env_vars = {
    HTTP_PORT = 5050
  }
}

module "echo_gateway" {
  source                = "../../elements/gateway"
  host                  = "echo"
  zone                  = var.cloudflare_zone
  service               = module.echo_application.service
  keycloak_realm_name   = var.keycloak_realm_name
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = var.default_client_scopes
}
