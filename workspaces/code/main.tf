terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
  }
}

locals {
  host           = "code"
  domain         = "${local.host}.${var.cloudflare_zone_name}"
  node_home_path = "/mnt/${var.volume_name}/files/home/${var.user_name}"
}

module "code_namespace" {
  source = "../../modules/code"
  name   = "code"
}

module "code_cluster_admin_service_account" {
  source    = "../../modules/cluster_admin_service_account"
  namespace = module.code_namespace.name
}

# module "code_application" {
#   source               = "../../elements/application"
#   name                 = "code"
#   namespace            = kubernetes_namespace_v1.code.metadata[0].name
#   ports                = [3333, 3838, 5500, 8888]
#   image                = var.image
#   node_name            = var.node_name
#   privileged           = true
#   service_account_name = kubernetes_service_account_v1.code_cluster_admin.metadata[0].name
#   env_vars = {
#     USER                                = var.user_name
#     DEFAULT_USER                        = var.user_name
#     CONNECTION_TOKEN                    = "dummy"
#     PROXY_DOMAIN                        = local.domain
#     VSCODE_PROXY_URI                    = "https://{{port}}.${var.cloudflare_zone_name}"
#     GITHUB_TOKEN                        = var.github_pat
#     EXTENSIONS_GALLERY                  = var.extensions_gallery_json
#     CS_DISABLE_GETTING_STARTED_OVERRIDE = "true"
#   }
#   volumes = [
#     {
#       volume_name = "home"
#       mount_path  = "/home/${var.user_name}/"
#       host_path   = local.node_home_path
#       mount_type  = "Directory"
#     },
#     {
#       volume_name = "cron"
#       mount_path  = "/var/spool/cron/"
#       host_path   = "/mnt/${var.volume_name}/cron/${var.user_name}/var/spool/cron/"
#       mount_type  = "DirectoryOrCreate"
#     },
#     {
#       volume_name = "docker"
#       mount_path  = "/var/run/docker.sock"
#       host_path   = "/var/run/docker.sock"
#       mount_type  = "Socket"
#     }
#   ]
#   depends_on = [
#     null_resource.code_permissions
#   ]
# }

# module "code_gateway" {
#   source                = "../../elements/gateway"
#   host                  = local.host
#   zone_id               = var.cloudflare_zone_id
#   zone_name             = var.cloudflare_zone_name
#   service               = module.code_application.service
#   keycloak_realm_id     = var.keycloak_realm_id
#   keycloak_url          = var.keycloak_url
#   keycloak_groups       = ["Administrator"]
#   default_client_scopes = ["groups"]
#   annotations = {
#     "nginx.ingress.kubernetes.io/configuration-snippet" = <<EOF
#       proxy_set_header Accept-Encoding "";
#       sub_filter '</head>' '
#       <link rel=\"stylesheet\" href=\"/_static/src/browser/media/fonts/${var.code_font}/${var.code_font}.css\">
#       <link rel=\"stylesheet\" href=\"/_static/src/browser/media/fonts/${var.body_font}/${var.body_font}.css\">
#       </head>';
#       sub_filter_once on;
#     EOF
#   }
# }

# module "code_port_gateway" {
#   for_each  = toset(["3838", "5500", "8888"])
#   source    = "../../elements/gateway"
#   host      = each.value
#   zone_id   = var.cloudflare_zone_id
#   zone_name = var.cloudflare_zone_name
#   service = merge(
#     module.code_application.service,
#     { port = tonumber(each.value) }
#   )
#   keycloak_realm_id     = var.keycloak_realm_id
#   keycloak_url          = var.keycloak_url
#   keycloak_groups       = ["Administrator"]
#   default_client_scopes = ["groups"]
# }

# module "code_test_gateway" {
#   source    = "../../elements/gateway"
#   host      = "test"
#   zone_id   = var.cloudflare_zone_id
#   zone_name = var.cloudflare_zone_name
#   service = {
#     name      = "test"
#     port      = 8888
#     namespace = kubernetes_namespace_v1.code.metadata[0].name
#   }
#   keycloak_realm_id     = var.keycloak_realm_id
#   keycloak_url          = var.keycloak_url
#   keycloak_groups       = ["Tester"]
#   default_client_scopes = ["groups"]
# }
