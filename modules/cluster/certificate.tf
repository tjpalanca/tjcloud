resource "cloudflare_origin_ca_certificate" "origin_ca" {
  hostnames          = [var.cloudflare_zone, "*.${var.cloudflare_zone}"]
  request_type       = "origin-rsa"
  requested_validity = 15 * 365
}
