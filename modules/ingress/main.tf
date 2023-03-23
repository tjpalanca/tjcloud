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
}

data "tfe_outputs" "cloudflare" {
  organization = "tjpalanca"
  workspace    = "tjcloud-cloudflare"
}

locals {
  domain = "${var.subdomain}.${var.zone_name}"
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "${var.service_name}-${var.service_namespace}-${var.service_port}"
    namespace = var.service_namespace
    annotations = merge(
      {
        "nginx.ingress.kubernetes.io/auth-tls-secret"        = data.tfe_outputs.cloudflare.values.authenticated_origin_pulls_secret
        "nginx.ingress.kubernetes.io/auth-tls-verify-client" = "on"
      },
      var.annotations
    )
  }
  spec {
    ingress_class_name = data.tfe_outputs.cloudflare.values.ingress_class_name
    tls {
      hosts = [local.domain]
    }
    rule {
      host = local.domain
      http {
        path {
          backend {
            service {
              name = var.service_name
              port {
                number = var.service_port
              }
            }
          }
        }
      }
    }
  }
}

resource "cloudflare_record" "record" {
  zone_id = var.zone_id
  name    = var.subdomain
  value   = coalesce(var.cname_zone_name, var.zone_name)
  type    = "CNAME"
  proxied = true
}
