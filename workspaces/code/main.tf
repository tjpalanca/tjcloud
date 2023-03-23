terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud-code"
    }
  }
}

data "tfe_outputs" "digitalocean" {
  organization = "tjpalanca"
  workspace    = "tjcloud-digitalocean"
}

provider "kubernetes" {
  host                   = data.tfe_outputs.digitalocean.values.cluster.host
  token                  = data.tfe_outputs.digitalocean.values.cluster.token
  cluster_ca_certificate = data.tfe_outputs.digitalocean.values.cluster.cluster_ca_certificate
}

module "code_namespace" {
  source = "../../modules/namespace"
  name   = "code"
}

module "code_service_account" {
  source        = "../../modules/service_account"
  name          = "code"
  namespace     = module.code_namespace.name
  cluster_roles = ["cluster-admin"]
}

module "code_volume_claim" {
  source    = "../../modules/volume_claim"
  name      = "code"
  namespace = module.code_namespace.name
  size      = 20
}

module "code_deployment" {
  source               = "../../modules/deployment"
  name                 = "code"
  namespace            = module.code_namespace.name
  service_account_name = module.code_service_account.name
  ports                = [3333, 3838, 5500, 8888]
  image                = "ghcr.io/tjpalanca/tjcloud/code:latest"
  build_context        = "${path.module}/image"
  mount_docker_socket  = true
  env_vars = {
    USER                                = var.user_name
    DEFAULT_USER                        = var.user_name
    CONNECTION_TOKEN                    = "dummy"
    PROXY_DOMAIN                        = "code.${var.dev_zone_name}"
    VSCODE_PROXY_URI                    = "https://{{port}}.${var.dev_zone_name}"
    CS_DISABLE_GETTING_STARTED_OVERRIDE = "true"
  }
  mounts = [
    {
      mount_path  = "/home/${var.user_name}/"
      volume_path = "files/home/${var.user_name}/"
      claim_name  = module.code_volume_claim.name
      owner_uid   = 1000
    },
    {
      mount_path  = "/var/spool/cron/"
      volume_path = "files/var/spool/cron/"
      claim_name  = module.code_volume_claim.name
      owner_uid   = 1000
    }
  ]
}

resource "kubernetes_service_v1" "code" {
  metadata {
    name      = "code"
    namespace = "code"
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "code"
    }
    port {
      name        = "http"
      port        = 3333
      target_port = 3333
    }
  }
}

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
