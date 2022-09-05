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


module "pgadmin" {
  source    = "../../elements/application"
  name      = "pgadmin"
  namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
  ports     = [5050]
  image     = "dpage/pgadmin4:6.13"
  env_vars = {
    PGADMIN_DEFAULT_EMAIL                     = var.pgadmin_default_username
    PGADMIN_DEFAULT_PASSWORD                  = var.pgadmin_default_password
    PGADMIN_LISTEN_ADDRESS                    = "0.0.0.0"
    PGADMIN_LISTEN_PORT                       = "5050"
    PGADMIN_CONFIG_SERVER_MODE                = "True"
    PGADMIN_CONFIG_AUTHENTICATION_SOURCES     = "['webserver']"
    PGADMIN_CONFIG_WEBSERVER_AUTO_CREATE_USER = "True"
    PGADMIN_CONFIG_WEBSERVER_REMOTE_USER      = "'X-Forwarded-User'"
  }
  volumes = [{
    volume_name = "pgadmin-config"
    mount_path  = "/var/lib/pgadmin/"
    host_path   = "/mnt/${var.volume_name}/pgadmin/"
    mount_type  = "DirectoryOrCreate"
  }]
}

module "pgadmin_gateway" {
  source                = "../../elements/gateway"
  host                  = "pgadmin"
  zone                  = var.pgadmin_cloudflare_zone
  service               = module.pgadmin.service
  keycloak_realm_name   = var.keycloak_realm_name
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = var.default_client_scopes
}
