resource "tls_private_key" "origin_certificate" {
  algorithm = "RSA"
}

resource "tls_cert_request" "origin_certificate" {
  private_key_pem = tls_private_key.origin_certificate.private_key_pem
  subject {
    common_name  = var.dev_zone_name
    organization = "TJ Palanca"
  }
}

resource "cloudflare_origin_ca_certificate" "origin_certificate" {
  provider           = cloudflare.cloudflare_origin_ca_key
  csr                = tls_cert_request.origin_certificate.cert_request_pem
  hostnames          = [var.dev_zone_name, "*.${var.dev_zone_name}"]
  request_type       = "origin-rsa"
  requested_validity = 365 * 15 # years
}

resource "kubernetes_secret_v1" "origin_certificate" {
  type = "kubernetes.io/tls"
  metadata {
    name      = "origin-certificate"
    namespace = kubernetes_namespace_v1.ingress_nginx.metadata[0].name
  }
  data = {
    "tls.key" = tls_private_key.origin_certificate.private_key_pem
    "tls.crt" = cloudflare_origin_ca_certificate.origin_certificate.certificate
  }
}
