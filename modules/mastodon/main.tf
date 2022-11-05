terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
  }
}

resource "kubernetes_namespace_v1" "mastodon" {
  metadata {
    name = "mastodon"
  }
}

module "mastodon_application" {
  source       = "../../elements/application"
  name         = "mastodon"
  namespace    = kubernetes_namespace_v1.mastodon.metadata[0].name
  service_type = "ClusterIP"
  ports        = [3000]
  image        = "ghcr.io/mastodon/mastodon:latest"
  env_vars = {

  }
}

module "mastodon_ingress" {
  source    = "../../elements/ingress"
  service   = module.mastodon_application.service
  host      = "mastodon"
  zone_id   = var.cloudflare_zone_id
  zone_name = var.cloudflare_zone_name
  cname     = var.main_cloudflare_zone_name
}
