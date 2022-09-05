terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

locals {
  host   = coalesce(var.host, var.service.name)
  domain = "${local.host}.${var.zone}"
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name        = "${var.service.name}-ingress"
    namespace   = var.service.namespace
    annotations = var.annotations
  }
  spec {
    ingress_class_name = var.ingress_class_name
    tls {
      hosts = [local.domain]
    }
    rule {
      host = local.domain
      http {
        path {
          path = var.path
          backend {
            service {
              name = var.service.name
              port {
                number = var.service.port
              }
            }
          }
        }
      }
    }
  }
}

data "cloudflare_zone" "zone" {
  name = var.zone
}

resource "cloudflare_record" "record" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = local.host
  value   = var.zone
  type    = "CNAME"
  proxied = true
}
