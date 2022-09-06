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
  source          = "./modules/cluster"
  cluster_name    = var.cluster_name
  cloudflare_zone = var.main_cloudflare_zone
  linode_region   = var.linode_region
  root_password   = var.root_password
  linode_token    = var.linode_token
  local_ssh_key   = var.local_ssh_key
}

module "database" {
  source                    = "./modules/database"
  main_postgres_username    = var.main_postgres_username
  main_postgres_database    = var.main_postgres_database
  main_postgres_password    = var.main_postgres_password
  main_postgres_node_name   = module.cluster.main_node.label
  main_postgres_node_ip     = module.cluster.main_node.ip_address
  main_postgres_volume_name = module.cluster.main_node_volume.label
  depends_on = [
    module.cluster
  ]
}

module "ingress_nginx_controller" {
  source = "./modules/ingress_nginx_controller"
  cloudflare_origin_ca = {
    common_name  = var.cloudflare_origin_ca_common_name
    organization = var.cloudflare_origin_ca_organization
    private_key  = var.cloudflare_origin_ca_private_key
  }
  cloudflare_zone = var.main_cloudflare_zone
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
  depends_on = [
    module.cluster
  ]
}

module "keycloak" {
  source = "./modules/keycloak"
  providers = {
    postgresql = postgresql.main
  }
  database = module.database.main_postgres_database_credentials
  keycloak = {
    image           = module.keycloak_image.image.versioned
    cloudflare_zone = var.main_cloudflare_zone
    subdomain       = var.keycloak_subdomain
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

module "pgadmin" {
  source                   = "./modules/pgadmin"
  pgadmin_default_username = var.pgadmin_default_username
  pgadmin_default_password = var.pgadmin_default_password
  pgadmin_cloudflare_zone  = var.main_cloudflare_zone
  keycloak_realm_name      = module.keycloak_config.realms.main.realm
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

module "echo" {
  source                = "./modules/echo"
  cloudflare_zone       = var.main_cloudflare_zone
  keycloak_realm_name   = module.keycloak_config.realms.main.realm
  keycloak_url          = module.keycloak.url
  default_client_scopes = [module.keycloak_config.client_scopes.groups.name]
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "code" {
  source = "./modules/code"
}
