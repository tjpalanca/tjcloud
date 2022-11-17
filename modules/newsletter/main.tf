terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.21.0"
    }
  }
}

locals {
  host = "newsletter"
}

resource "kubernetes_namespace_v1" "newsletter" {
  metadata {
    name = "newsletter"
  }
}

module "newsletter_application" {
  source       = "../../elements/application"
  name         = "newsletter"
  namespace    = kubernetes_namespace_v1.newsletter.metadata.0.name
  service_type = "ClusterIP"
  ports        = [8080]
  host_ports = [{
    name           = "email"
    container_port = 2525
    host_port      = 25
    protocol       = "TCP"
  }]
  replicas = 1
  image    = var.image
  volumes = [{
    volume_name = "data"
    mount_path  = "/kill-the-newsletter/data"
    host_path   = "/mnt/${var.volume_name}/newsletter/"
    mount_type  = "DirectoryOrCreate"
  }]
}

module "newsletter_gateway" {
  source                = "../../elements/gateway"
  service               = module.newsletter_application.service
  host                  = local.host
  zone_id               = var.cloudflare_zone_id
  zone_name             = var.cloudflare_zone_name
  cname                 = var.main_cloudflare_zone_name
  add_record            = false
  keycloak_realm_id     = var.keycloak_realm_id
  keycloak_url          = var.keycloak_url
  keycloak_groups       = ["Administrator"]
  default_client_scopes = ["groups"]
  additional_configuration = {
    OAUTH2_PROXY_SKIP_AUTH_ROUTES = "/feeds/.+\\.xml,/favicon\\.ico"
  }
}

resource "cloudflare_record" "a" {
  zone_id = var.cloudflare_zone_id
  name    = local.host
  value   = var.node_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "mx" {
  zone_id  = var.cloudflare_zone_id
  name     = local.host
  value    = "${local.host}.${var.cloudflare_zone_name}"
  type     = "MX"
  priority = 10
}
