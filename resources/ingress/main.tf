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

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.name
  }
  spec {
    ingress_class_name = var.ingress_class_name
    rule {
      host = "${var.host}.${var.zone}"
      http {
        path {
          path = var.path
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



data "cloudflare_zone" "zone" {
  name = var.zone
}

resource "cloudflare_record" "record" {
  zone_id = data.cloudflare_zone.zone.zone_id
  name    = var.host
  value   = var.zone
  type    = "CNAME"
  proxied = true
}
