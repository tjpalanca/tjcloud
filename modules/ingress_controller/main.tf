terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

resource "tls_cert_request" "origin_ca_cert_request" {
  private_key_pem = var.cloudflare_origin_ca.private_key
  subject {
    common_name  = var.cloudflare_origin_ca.common_name
    organization = var.cloudflare_origin_ca.organization
  }
}

resource "cloudflare_origin_ca_certificate" "origin_ca" {
  csr                = tls_cert_request.origin_ca_cert_request.cert_request_pem
  hostnames          = [var.cloudflare_zone, "*.${var.cloudflare_zone}"]
  request_type       = "origin-rsa"
  requested_validity = 15 * 365
}

resource "kubernetes_secret_v1" "origin_ca" {
  type = "kubernetes.io/tls"
  metadata {
    name      = "origin-ca"
    namespace = "ingress-nginx"
  }
  data = {
    "tls.key" = var.cloudflare_origin_ca.private_key
    "tls.crt" = cloudflare_origin_ca_certificate.origin_ca.certificate
  }
}

module "nginx_ingress_controller" {
  source                  = "../../resources/nginx_ingress_controller"
  default_ssl_certificate = "${kubernetes_secret_v1.origin_ca.metadata.0.namespace}/${kubernetes_secret_v1.origin_ca.metadata.0.name}"
}