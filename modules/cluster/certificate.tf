resource "tls_cert_request" "origin_ca_cert_request" {
  key_algorithm   = var.cloudflare_origin_ca.private_key
  private_key_pem = var.cloudflare_origin_ca.private_key_algo
  subject {
    common_name  = var.cloudflare_origin_ca.common_name
    organization = var.cloudflare_origin_ca.organization
  }
}

resource "cloudflare_origin_ca_certificate" "origin_ca" {
  csr                = tls_cert_request.origin_ca_cert_request.cert_request_pem
  hostnames          = [var.main_cloudflare_zone, "*.${var.main_cloudflare_zone}"]
  request_type       = "origin-rsa"
  requested_validity = 15 * 365
}
