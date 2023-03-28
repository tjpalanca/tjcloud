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

resource "kubernetes_namespace_v1" "mastodon" {
  metadata {
    name = "mastodon"
  }
}

locals {
  host  = "mastodon"
  image = "tootsuite/mastodon:${var.mastodon_version}"
  envs = {
    LOCAL_DOMAIN                    = var.cloudflare_zone_name
    WEB_DOMAIN                      = "${local.host}.${var.cloudflare_zone_name}"
    SECRET_KEY_BASE                 = var.secret_key_base
    OTP_SECRET                      = var.otp_secret
    VAPID_PRIVATE_KEY               = var.vapid_private_key
    VAPID_PUBLIC_KEY                = var.vapid_public_key
    RAILS_ENV                       = "production"
    NODE_ENV                        = "production"
    RAILS_SERVE_STATIC_FILES        = "true"
    STREAMING_API_BASE_URL          = "wss://${local.host}-streaming.${var.cloudflare_zone_name}"
    SINGLE_USER_MODE                = "false"
    DEFAULT_LOCALE                  = "en"
    SMTP_SERVER                     = var.smtp_server
    SMTP_PORT                       = tostring(var.smtp_port)
    SMTP_FROM_ADDRESS               = "mastodon@${var.cloudflare_zone_name}"
    DB_HOST                         = var.postgres_host
    DB_USER                         = var.postgres_user
    DB_PASS                         = var.postgres_pass
    DB_NAME                         = postgresql_database.mastodon.name
    DB_PORT                         = tostring(var.postgres_port)
    REDIS_HOST                      = var.redis_host
    REDIS_PORT                      = tostring(var.redis_port)
    REDIS_NAMESPACE                 = "mastodon"
    ES_ENABLED                      = "false"
    TRUSTED_PROXY_IP                = "10.2.0.9"
    RAILS_LOG_LEVEL                 = "warn"
    WEB_CONCURRENCY                 = 0
    MAX_THREADS                     = 4
    STREAMING_CLUSTER_NUM           = 2
    SKIP_POST_DEPLOYMENT_MIGRATIONS = var.skip_post_deployment ? "true" : "false"
    S3_ENABLED                      = "true"
    S3_BUCKET                       = var.s3_bucket.label
    AWS_ACCESS_KEY_ID               = var.s3_access_key
    AWS_SECRET_ACCESS_KEY           = var.s3_secret_key
    S3_REGION                       = var.s3_bucket.cluster
    S3_PROTOCOL                     = "https"
    S3_ENDPOINT                     = "https://${var.s3_bucket.domain}"
    S3_HOSTNAME                     = var.s3_bucket.domain
    S3_ALIAS_HOST                   = var.s3_bucket.label
  }
  host_path = "/mnt/${var.volume_name}/mastodon/"
  web_port  = 3000
  web_probes = [{
    path                  = "/health"
    port                  = local.web_port
    initial_delay_seconds = 10
    period_seconds        = 10
    timeout_seconds       = 10
  }]
  streaming_port = 4000
  streaming_probes = [{
    path = "/api/v1/streaming/health"
    port = local.streaming_port
  }]
}

resource "postgresql_database" "mastodon" {
  name = "mastodon"
}

module "mastodon_permissions" {
  source          = "../../elements/permissions"
  node_password   = var.node_password
  node_ip_address = var.node_ip
  node_path       = local.host_path
  uid             = 991
}

module "mastodon_application" {
  source           = "../../elements/application"
  name             = "mastodon"
  replicas         = var.disabled ? 0 : 1
  namespace        = kubernetes_namespace_v1.mastodon.metadata[0].name
  ports            = [local.web_port]
  image            = local.image
  env_vars         = local.envs
  node_name        = var.node_name
  liveness_probes  = local.web_probes
  readiness_probes = local.web_probes
  command = [
    "bash", "-c",
    "bundle exec rails db:migrate; bundle exec rails s -p ${local.web_port};"
  ]
  depends_on = [
    module.mastodon_permissions
  ]
}

module "mastodon_ingress" {
  source    = "../../elements/ingress"
  service   = module.mastodon_application.service
  host      = local.host
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  cname     = var.main_cloudflare_zone_name
  annotations = {
    "nginx.ingress.kubernetes.io/proxy-body-size" = "100m"
  }
}

module "mastodon_streaming" {
  source           = "../../elements/application"
  name             = "mastodon-streaming"
  replicas         = var.disabled ? 0 : 1
  namespace        = kubernetes_namespace_v1.mastodon.metadata[0].name
  ports            = [local.streaming_port]
  image            = local.image
  env_vars         = local.envs
  command          = ["node", "./streaming"]
  liveness_probes  = local.streaming_probes
  readiness_probes = local.streaming_probes
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
  replicas  = var.disabled ? 0 : 1
  namespace = kubernetes_namespace_v1.mastodon.metadata[0].name
  image     = local.image
  env_vars  = local.envs
  node_name = var.node_name
  command   = ["bundle", "exec", "sidekiq", "-c", "2"]
  depends_on = [
    module.mastodon_permissions
  ]
}
