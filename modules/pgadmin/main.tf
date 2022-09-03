terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "pgadmin" {
  metadata {
    name = "pgadmin"
  }
}

locals {
  port = 5050
}

module "pgadmin" {
  source    = "../../elements/application"
  name      = "pgadmin"
  namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
  ports     = [local.port]
  image     = "dpage/pgadmin4:6.12"
  env_vars = {
    PGADMIN_DEFAULT_EMAIL      = var.pgadmin_default_username
    PGADMIN_DEFAULT_PASSWORD   = var.pgadmin_default_password
    PGADMIN_LISTEN_ADDRESS     = "0.0.0.0"
    PGADMIN_LISTEN_PORT        = tostring(local.port)
    PGADMIN_CONFIG_SERVER_MODE = "True"
  }
}

module "pgadmin_ingress" {
  source       = "../../elements/ingress"
  name         = "pgadmin"
  namespace    = kubernetes_namespace_v1.pgadmin.metadata.0.name
  host         = "pgadmin"
  zone         = var.pgadmin_cloudflare_zone
  service_name = module.pgadmin.service_name
  service_port = local.port
}
