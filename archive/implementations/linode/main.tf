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
      version = "3.21.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.0.1"
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
  source             = "../../modules/cluster"
  cluster_name       = var.cluster_name
  cloudflare_zone_id = var.main_cloudflare_zone_id
  linode_region      = var.linode_region
  root_password      = var.root_password
  linode_token       = var.linode_token
  local_ssh_key      = var.local_ssh_key
}

module "firewall" {
  name        = var.cluster_name
  source      = "../../modules/firewall"
  node_ids    = module.cluster.node_ids
  allowed_ips = [var.home_ip]
}

module "storage" {
  source                      = "../../modules/storage"
  user_name                   = var.user_name
  public_cloudflare_zone_id   = var.public_cloudflare_zone_id
  public_cloudflare_zone_name = var.public_cloudflare_zone_name
}

module "database" {
  source                        = "../../modules/database"
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
  main_redis_node_name          = module.cluster.main_node.label
  main_redis_volume_name        = module.cluster.main_node_volume.label
  depends_on = [
    module.cluster
  ]
}

module "ingress_nginx_controller" {
  source = "../../modules/ingress_nginx_controller"
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
  source = "../../modules/kaniko"
  depends_on = [
    module.cluster
  ]
}

module "keycloak_image" {
  source        = "../../elements/image"
  name          = "keycloak"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "../../modules/keycloak/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/keycloak"
  image_version = "v1.0"
  node          = module.cluster.main_node
  node_password = var.root_password
}

module "keycloak" {
  source = "../../modules/keycloak"
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

module "keycloak_realms" {
  source       = "../../modules/keycloak-realms"
  admin_emails = var.admin_emails
  google = {
    client_id     = var.google_client_id
    client_secret = var.google_client_secret
  }
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "metrics_server" {
  source = "../../modules/metrics_server"
}

module "dashboard" {
  source               = "../../modules/dashboard"
  namespace            = "dashboard"
  cloudflare_zone_id   = var.main_cloudflare_zone_id
  cloudflare_zone_name = var.main_cloudflare_zone_name
  keycloak_realm_id    = module.keycloak_realms.main.id
  keycloak_url         = module.keycloak.url
  depends_on = [
    module.metrics_server
  ]
}

module "code_image" {
  source        = "../../elements/image"
  name          = "code"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "../../modules/code/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/code"
  node          = module.cluster.main_node
  node_password = var.root_password
  timeout       = "30m"
  build_args = {
    DEFAULT_USER = var.user_name
  }
  post_copy_commands = [
    "chmod +x scripts/*"
  ]
}

module "code" {
  source                  = "../../modules/code"
  cloudflare_zone_id      = var.main_cloudflare_zone_id
  cloudflare_zone_name    = var.main_cloudflare_zone_name
  image                   = module.code_image.image.versioned
  user_name               = var.user_name
  github_pat              = var.github_pat
  extensions_gallery_json = var.extensions_gallery_json
  keycloak_realm_id       = module.keycloak_realms.main.id
  keycloak_url            = module.keycloak.url
  volume_name             = module.cluster.main_node_volume.label
  node_ip_address         = module.cluster.main_node.ip_address
  node_password           = var.root_password
  node_name               = module.cluster.main_node.label
  code_font               = "JuliaMono"
  body_font               = "IBMPlexSans"
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "echo" {
  source               = "../../modules/echo"
  cloudflare_zone_id   = var.main_cloudflare_zone_id
  cloudflare_zone_name = var.main_cloudflare_zone_name
  keycloak_realm_id    = module.keycloak_realms.main.id
  keycloak_url         = module.keycloak.url
  depends_on = [
    module.cluster,
    module.keycloak
  ]
}

module "mail" {
  source         = "../../modules/mail"
  relay_host     = "smtp.mailgun.org"
  relay_username = var.mailgun_username
  relay_password = var.mailgun_password
}

module "pgadmin" {
  source                   = "../../modules/pgadmin"
  pgadmin_default_username = var.pgadmin_default_username
  pgadmin_default_password = var.pgadmin_default_password
  cloudflare_zone_id       = var.main_cloudflare_zone_id
  cloudflare_zone_name     = var.main_cloudflare_zone_name
  keycloak_realm_id        = module.keycloak_realms.main.id
  keycloak_url             = module.keycloak.url
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
  source = "../../modules/plausible"
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
}

module "mastodon" {
  source   = "../../modules/mastodon"
  disabled = true
  providers = {
    postgresql = postgresql.main
  }
  cloudflare_zone_id        = var.public_cloudflare_zone_id
  cloudflare_zone_name      = var.public_cloudflare_zone_name
  main_cloudflare_zone_id   = var.main_cloudflare_zone_id
  main_cloudflare_zone_name = var.main_cloudflare_zone_name
  secret_key_base           = var.mastodon_secret_key_base
  otp_secret                = var.mastodon_otp_secret
  vapid_private_key         = var.mastodon_vapid_private_key
  vapid_public_key          = var.mastodon_vapid_public_key
  smtp_server               = "${module.mail.service.name}.${module.mail.service.namespace}"
  smtp_port                 = module.mail.service.port
  postgres_host             = module.database.main_postgres_credentials.internal_host
  postgres_port             = module.database.main_postgres_credentials.internal_port
  postgres_user             = module.database.main_postgres_credentials.username
  postgres_pass             = module.database.main_postgres_credentials.password
  redis_host                = "${module.database.main_redis_service.name}.${module.database.main_redis_service.namespace}"
  redis_port                = module.database.main_redis_service.port
  node_name                 = module.cluster.main_node.label
  volume_name               = module.cluster.main_node_volume.label
  node_ip                   = module.cluster.main_node.ip_address
  node_password             = var.root_password
  mastodon_version          = "v4.1.0"
  skip_post_deployment      = false
  s3_bucket                 = module.storage.media_bucket
  s3_access_key             = var.mastodon_s3_access_key
  s3_secret_key             = var.mastodon_s3_secret_key
}

module "freshrss" {
  source   = "../../modules/freshrss"
  disabled = true
  providers = {
    postgresql = postgresql.main
  }
  cloudflare_zone_id        = var.public_cloudflare_zone_id
  cloudflare_zone_name      = var.public_cloudflare_zone_name
  main_cloudflare_zone_id   = var.main_cloudflare_zone_id
  main_cloudflare_zone_name = var.main_cloudflare_zone_name
  node_name                 = module.cluster.main_node.label
  volume_name               = module.cluster.main_node_volume.label
  admin_email               = var.admin_emails[0]
  postgres_host             = module.database.main_postgres_credentials.internal_host
  admin_username            = var.freshrss_admin_username
  admin_password            = var.freshrss_admin_password
  node_ip                   = module.cluster.main_node.ip_address
  node_password             = var.root_password
}

module "newsletter_image" {
  source        = "../../elements/image"
  name          = "newsletter"
  namespace     = module.kaniko.namespace
  registry      = local.ghcr_registry
  build_context = "../../modules/newsletter/image/"
  image_address = "ghcr.io/tjpalanca/tjcloud/newsletter"
  image_version = "v1.0"
  node          = module.cluster.main_node
  node_password = var.root_password
}

module "newsletter" {
  source                    = "../../modules/newsletter"
  disabled                  = true
  image                     = module.newsletter_image.image.versioned
  cloudflare_zone_id        = var.public_cloudflare_zone_id
  cloudflare_zone_name      = var.public_cloudflare_zone_name
  main_cloudflare_zone_id   = var.main_cloudflare_zone_id
  main_cloudflare_zone_name = var.main_cloudflare_zone_name
  volume_name               = module.cluster.main_node_volume.label
  node_ip                   = module.cluster.main_node.ip_address
  keycloak_realm_id         = module.keycloak_realms.main.id
  keycloak_url              = module.keycloak.url
}