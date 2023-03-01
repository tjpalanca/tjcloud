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
  port      = 8080
  host      = "rss"
  host_path = "/mnt/${var.volume_name}/freshrss"
}

resource "random_password" "freshrss" {
  length  = 16
  special = false
}

resource "postgresql_role" "freshrss" {
  name     = "freshrss"
  password = random_password.freshrss.result
  login    = true
}

resource "postgresql_database" "freshrss" {
  name  = "freshrss"
  owner = postgresql_role.freshrss.name
}

resource "kubernetes_namespace_v1" "freshrss" {
  metadata {
    name = "freshrss"
  }
}

module "freshrss_permissions" {
  source          = "../../elements/permissions"
  node_password   = var.node_password
  node_ip_address = var.node_ip
  node_path       = "${local.host_path}/"
  uid             = 33
}

module "freshrss_application" {
  source    = "../../elements/application"
  name      = "freshrss"
  namespace = kubernetes_namespace_v1.freshrss.metadata[0].name
  ports     = [local.port]
  image     = "freshrss/freshrss:latest"
  node_name = var.node_name
  replicas  = 0
  env_vars = {
    TZ               = "Asia/Singapore"
    CRON_MIN         = "13,43" # Every 30 minutes 
    LISTEN           = "0.0.0.0:${local.port}"
    FRESHRSS_INSTALL = <<EOF
      --api_enabled
      --base_url https://${local.host}.${var.cloudflare_zone_name}
      --db-base ${postgresql_database.freshrss.name}
      --db-host ${var.postgres_host}
      --db-password ${postgresql_role.freshrss.password}
      --db-type pgsql
      --db-user ${postgresql_role.freshrss.name}
      --default_user ${var.admin_username}
      --language en
    EOF
    FRESHRSS_USER    = <<EOF
      --api_password ${var.admin_password}
      --email ${var.admin_email}
      --language en
      --password ${var.admin_password}
      --user ${var.admin_username}
    EOF
  }
  volumes = [
    {
      volume_name = "data"
      mount_path  = "/var/www/FreshRSS/data"
      host_path   = "${local.host_path}/data"
      mount_type  = "DirectoryOrCreate"
    },
    {
      volume_name = "extensions"
      mount_path  = "/var/www/FreshRSS/extensions"
      host_path   = "${local.host_path}/extensions"
      mount_type  = "DirectoryOrCreate"
    }
  ]
  liveness_probes = [{
    path = "/api/greader.php"
    port = local.port
  }]
  readiness_probes = [{
    path = "/api/greader.php"
    port = local.port
  }]
  depends_on = [
    module.freshrss_permissions
  ]
}

module "freshrss_ingress" {
  source    = "../../elements/ingress"
  service   = module.freshrss_application.service
  host      = local.host
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  cname     = var.main_cloudflare_zone_name
}
