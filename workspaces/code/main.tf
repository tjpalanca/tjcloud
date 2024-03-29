terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.18.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.1.0"
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

provider "cloudflare" {
  api_token = var.cloudflare_api_token
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
  privileged           = true
  mount_docker_socket  = true
  env_vars = {
    USER                                = var.user_name
    DEFAULT_USER                        = var.user_name
    USERID                              = 1000
    GROUPID                             = 1000
    CONNECTION_TOKEN                    = "dummy"
    PROXY_DOMAIN                        = "code.${var.dev_zone_name}"
    VSCODE_PROXY_URI                    = "https://{{port}}.${var.dev_zone_name}"
    EXTENSIONS_GALLERY_JSON             = var.extensions_gallery_json
    CS_DISABLE_GETTING_STARTED_OVERRIDE = true
    ROOT                                = true
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

module "code_service" {
  source     = "../../modules/service"
  name       = "code"
  namespace  = module.code_deployment.namespace
  deployment = module.code_deployment.name
  ports      = module.code_deployment.ports
}

module "code_ingress" {
  source            = "../../modules/ingress"
  subdomain         = "code"
  zone_id           = var.dev_zone_id
  zone_name         = var.dev_zone_name
  cname_zone_name   = var.dev_zone_name
  service_name      = module.code_service.name
  service_port      = 3333
  service_namespace = module.code_service.namespace
  annotations = {
    "nginx.ingress.kubernetes.io/configuration-snippet" = <<EOF
      proxy_set_header Accept-Encoding "";
      sub_filter '</head>' '
      <link rel=\"stylesheet\" href=\"/_static/src/browser/media/fonts/${var.code_font}/${var.code_font}.css\">
      <link rel=\"stylesheet\" href=\"/_static/src/browser/media/fonts/${var.body_font}/${var.body_font}.css\">
      </head>';
      sub_filter_once on;
    EOF
  }
}

module "code_port_ingress" {
  for_each          = toset(["3838", "5500", "8888"])
  source            = "../../modules/ingress"
  subdomain         = each.value
  zone_id           = var.dev_zone_id
  zone_name         = var.dev_zone_name
  cname_zone_name   = var.dev_zone_name
  service_name      = module.code_service.name
  service_port      = tonumber(each.value)
  service_namespace = module.code_service.namespace
}

module "code_gateway" {
  source         = "../../modules/gateway"
  name           = "VS Code"
  logo_url       = "https://storage.tjpalanca.com/images/hotlink-ok/logos/code-512.png"
  zone_id        = module.code_ingress.zone_id
  domain         = module.code_ingress.domain
  allowed_groups = ["Administrators"]
}

module "code_port_gateway" {
  for_each       = module.code_port_ingress
  source         = "../../modules/gateway"
  name           = "VS Code (${each.value.subdomain})"
  logo_url       = "https://storage.tjpalanca.com/images/hotlink-ok/logos/code-512.png"
  zone_id        = each.value.zone_id
  domain         = each.value.domain
  allowed_groups = ["Administrators"]
}
