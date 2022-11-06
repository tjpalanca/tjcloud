terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.17.1"
    }
  }
}

locals {
  image = "ghcr.io/mastodon/mastodon:latest"
}

resource "kubernetes_namespace_v1" "mastodon" {
  metadata {
    name = "mastodon"
  }
}

locals {
  host = "mastodon"
  envs = {
    LOCAL_DOMAIN             = var.cloudflare_zone_name
    WEB_DOMAIN               = "${local.host}.${var.cloudflare_zone_name}"
    SECRET_KEY_BASE          = var.secret_key_base
    OTP_SECRET               = var.otp_secret
    VAPID_PRIVATE_KEY        = var.vapid_private_key
    VAPID_PUBLIC_KEY         = var.vapid_public_key
    RAILS_ENV                = "production"
    NODE_ENV                 = "production"
    RAILS_SERVE_STATIC_FILES = "true"
    STREAMING_API_BASE_URL   = "wss://${local.host}-streaming.${var.cloudflare_zone_name}"
    SINGLE_USER_MODE         = "true"
    DEFAULT_LOCALE           = "en"
    SMTP_SERVER              = var.smtp_server
    SMTP_PORT                = tostring(var.smtp_port)
    SMTP_FROM_ADDRESS        = "mastodon@${var.cloudflare_zone_name}"
    DB_HOST                  = var.postgres_host
    DB_USER                  = var.postgres_user
    DB_PASS                  = var.postgres_pass
    DB_NAME                  = postgresql_database.mastodon.name
    DB_PORT                  = tostring(var.postgres_port)
    REDIS_HOST               = var.redis_host
    REDIS_PORT               = tostring(var.redis_port)
    ES_ENABLED               = "false"
    # TRUSTED_PROXY_IP         = ""
  }
}

resource "postgresql_database" "mastodon" {
  name = "mastodon"
}

module "mastodon_application" {
  source    = "../../elements/application"
  name      = "mastodon"
  namespace = kubernetes_namespace_v1.mastodon.metadata[0].name
  ports     = [3000]
  image     = local.image
  command = [
    "bash", "-c",
    "bundle exec rails db:migrate; bundle exec rails s -p 3000;"
  ]
  env_vars = local.envs
}

module "mastodon_ingress" {
  source    = "../../elements/ingress"
  service   = module.mastodon_application.service
  host      = local.host
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  cname     = var.main_cloudflare_zone_name
}

module "mastodon_streaming" {
  source    = "../../elements/application"
  name      = "mastodon-streaming"
  namespace = kubernetes_namespace_v1.mastodon.metadata[0].name
  ports     = [4000]
  image     = local.image
  command   = ["node", "./streaming"]
  env_vars  = local.envs
}

module "mastodon_streaming_ingress" {
  source    = "../../elements/ingress"
  service   = module.mastodon_streaming.service
  host      = "${local.host}-streaming"
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  cname     = var.main_cloudflare_zone_name
}

module "mastodon_sidekiq" {
  source    = "../../elements/deployment"
  name      = "mastodon-sidekiq"
  namespace = kubernetes_namespace_v1.mastodon.metadata[0].name
  image     = local.image
  command   = ["bundle", "exec", "sidekiq"]
  env_vars  = local.envs
}
