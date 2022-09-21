terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "~> 1.29.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.35.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.10.0"
    }
  }
  cloud {
    organization = "tjpalanca"
    workspaces {
      name = "tjcloud"
    }
  }
}

locals {
  ghcr_registry = {
    server   = "ghcr.io"
    username = var.ghcr_username
    password = var.ghcr_password
    email    = var.ghcr_email
  }
}

module "cluster" {
  source             = "./modules/cluster"
  cluster_name       = var.cluster_name
  cloudflare_zone_id = var.main_cloudflare_zone_id
  linode_region      = var.linode_region
  root_password      = var.root_password
  linode_token       = var.linode_token
  local_ssh_key      = var.local_ssh_key
}

module "code_image" {
  source        = "./elements/image"
  name          = "code"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "modules/code/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/code"
  node          = module.cluster.main_node
  node_password = var.root_password
  build_args = {
    DEFAULT_USER = var.user_name
  }
  post_copy_commands = [
    "chmod +x scripts/*"
  ]
}

module "code" {
  source                  = "./modules/code"
  cloudflare_zone_id      = var.main_cloudflare_zone_id
  cloudflare_zone_name    = var.main_cloudflare_zone_name
  image                   = module.code_image.image.versioned
  user_name               = var.user_name
  github_pat              = var.github_pat
  extensions_gallery_json = var.extensions_gallery_json
  keycloak_realm_id       = module.keycloak_config.realms.main.id
  keycloak_url            = module.keycloak.url
  default_client_scopes   = [module.keycloak_config.client_scopes.groups.name]
  volume_name             = module.cluster.main_node_volume.label
  node_ip_address         = module.cluster.main_node.ip_address
  node_password           = var.root_password
  node_name               = module.cluster.main_node.label
  code_font               = "JetBrainsMono"
  body_font               = "IBMPlexSans"
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "metrics_server" {
  source = "./modules/metrics_server"
}

module "dashboard" {
  source                = "./modules/dashboard"
  namespace             = "dashboard"
  cloudflare_zone_id    = var.main_cloudflare_zone_id
  cloudflare_zone_name  = var.main_cloudflare_zone_name
  keycloak_realm_id     = module.keycloak_config.realms.main.id
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.metrics_server
  ]
}

module "database" {
  source                        = "./modules/database"
  main_postgres_username        = var.main_postgres_username
  main_postgres_database        = var.main_postgres_database
  main_postgres_password        = var.main_postgres_password
  main_postgres_node_name       = module.cluster.main_node.label
  main_postgres_node_ip         = module.cluster.main_node.ip_address
  main_postgres_volume_name     = module.cluster.main_node_volume.label
  main_clickhouse_database      = var.main_clickhouse_database
  main_clickhouse_username      = var.main_clickhouse_username
  main_clickhouse_password      = var.main_clickhouse_password
  main_clickhouse_node_ip       = module.cluster.main_node.ip_address
  main_clickhouse_node_name     = module.cluster.main_node.label
  main_clickhouse_volume_name   = module.cluster.main_node_volume.label
  main_clickhouse_node_password = var.root_password
  depends_on = [
    module.cluster
  ]
}

module "echo" {
  source                = "./modules/echo"
  cloudflare_zone_id    = var.main_cloudflare_zone_id
  cloudflare_zone_name  = var.main_cloudflare_zone_name
  keycloak_realm_id     = module.keycloak_config.realms.main.id
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "ingress_nginx_controller" {
  source = "./modules/ingress_nginx_controller"
  cloudflare_origin_ca = {
    common_name  = var.cloudflare_origin_ca_common_name
    organization = var.cloudflare_origin_ca_organization
    private_key  = var.cloudflare_origin_ca_private_key
  }
  cloudflare_zone_name = var.main_cloudflare_zone_name
  depends_on = [
    module.cluster
  ]
}

module "kaniko" {
  source = "./modules/kaniko"
  depends_on = [
    module.cluster
  ]
}

module "keycloak_image" {
  source        = "./elements/image"
  name          = "keycloak"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "modules/keycloak/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/keycloak"
  image_version = "v1.0"
  node          = module.cluster.main_node
  node_password = var.root_password
}

module "keycloak" {
  source = "./modules/keycloak"
  providers = {
    postgresql = postgresql.main
  }
  database = module.database.main_postgres_credentials
  keycloak = {
    image                = module.keycloak_image.image.versioned
    cloudflare_zone_id   = var.main_cloudflare_zone_id
    cloudflare_zone_name = var.main_cloudflare_zone_name
    subdomain            = var.keycloak_subdomain
  }
  admin = {
    username = var.keycloak_admin_username
    password = var.keycloak_admin_password
  }
  depends_on = [
    module.cluster
  ]
}

module "keycloak_config" {
  source = "./modules/keycloak-config"
  settings = {
    realm_name         = var.cluster_name
    realm_display_name = var.keycloak_realm_display_name
    admin_emails       = var.admin_emails
  }
  identity_providers = {
    google = {
      client_id     = var.google_client_id
      client_secret = var.google_client_secret
    }
  }
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "mail" {
  source         = "./modules/mail"
  relay_host     = "smtp.gmail.com"
  relay_username = var.gmail_username
  relay_password = var.gmail_password
}

module "pgadmin" {
  source                   = "./modules/pgadmin"
  pgadmin_default_username = var.pgadmin_default_username
  pgadmin_default_password = var.pgadmin_default_password
  cloudflare_zone_id       = var.main_cloudflare_zone_id
  cloudflare_zone_name     = var.main_cloudflare_zone_name
  keycloak_realm_id        = module.keycloak_config.realms.main.id
  keycloak_url             = module.keycloak.url
  default_client_scopes    = [module.keycloak_config.client_scopes.groups.name]
  volume_name              = module.cluster.main_node_volume.label
  node_ip_address          = module.cluster.main_node.ip_address
  node_password            = var.root_password
  node_name                = module.cluster.main_node.label
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "plausible" {
  source = "./modules/plausible"
  providers = {
    postgresql = postgresql.main
  }
  postgres              = module.database.main_postgres_credentials
  clickhouse            = module.database.main_clickhouse_credentials
  google_client_id      = var.google_client_id
  google_client_secret  = var.google_client_secret
  smtp_host             = "${module.mail.service.name}.${module.mail.service.namespace}"
  subdomain             = "analytics"
  cloudflare_zone_id    = var.public_cloudflare_zone_id
  cloudflare_zone_name  = var.public_cloudflare_zone_name
  cloudflare_zone_cname = var.main_cloudflare_zone_name
  secret_key_base       = var.plausible_secret_key_base
  admin_user = {
    email    = var.plausible_admin_user_email
    name     = var.plausible_admin_user_name
    password = var.plausible_admin_user_password
  }
}

module "storage" {
  source    = "./modules/storage"
  user_name = var.user_name
}
