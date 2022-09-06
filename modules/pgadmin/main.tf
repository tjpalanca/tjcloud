terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

locals {
  config_path = "/var/lib/pgadmin/"
  volume_path = "/mnt/${var.volume_name}/pgadmin/"
}

resource "kubernetes_namespace_v1" "pgadmin" {
  metadata {
    name = "pgadmin"
  }
}

resource "null_resource" "pgadmin" {
  connection {
    type     = "ssh"
    user     = "root"
    password = var.node_password
    host     = var.node_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.volume_path}",
      "chown -R 5050:5050 ${local.volume_path}"
    ]
  }
}

module "pgadmin_application" {
  source    = "../../elements/application"
  name      = "pgadmin"
  namespace = kubernetes_namespace_v1.pgadmin.metadata.0.name
  ports     = [5050]
  image     = "dpage/pgadmin4:6.13"
  node_name = var.node_name
  env_vars = {
    PGADMIN_DEFAULT_EMAIL                     = var.pgadmin_default_username
    PGADMIN_DEFAULT_PASSWORD                  = var.pgadmin_default_password
    PGADMIN_LISTEN_ADDRESS                    = "0.0.0.0"
    PGADMIN_LISTEN_PORT                       = "5050"
    PGADMIN_CONFIG_AUTHENTICATION_SOURCES     = "['webserver']"
    PGADMIN_CONFIG_WEBSERVER_AUTO_CREATE_USER = "True"
    PGADMIN_CONFIG_WEBSERVER_REMOTE_USER      = "'X-Forwarded-User'"
    PGADMIN_CONFIG_ENHANCED_COOKIE_PROTECTION = "False"
    PGADMIN_CONFIG_MASTER_PASSWORD_REQUIRED   = "True"
  }
  volumes = [{
    volume_name = "pgadmin-config"
    mount_path  = local.config_path
    host_path   = local.volume_path
    mount_type  = "DirectoryOrCreate"
  }]
  depends_on = [
    null_resource.pgadmin
  ]
}

module "pgadmin_gateway" {
  source                = "../../elements/gateway"
  host                  = "pgadmin"
  zone                  = var.pgadmin_cloudflare_zone
  service               = module.pgadmin_application.service
  keycloak_realm_name   = var.keycloak_realm_name
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = var.default_client_scopes
}
